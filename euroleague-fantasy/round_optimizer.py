#!/usr/bin/env python3
"""
EuroLeague Fantasy - optimizator kola (projekcija + kvote + trejdovi + T1/T2 balans).

PROJEKCIJA (ansambl tri klasicna modela):
  A) Tezinski prosek forme:  0.50*PIR_poslednje + 0.35*PIR_sezona + 0.15*PIR_prosla
  B) Bajesovsko sazimanje (regresija ka proseku): (n*sezona + K*prosla)/(n+K) + 0.30*(poslednje - sezona)
     -> igraci sa malo utakmica (npr. Kamenjas, 3 ut.) se vuku ka proslogodisnjem nivou
  C) Trziste: cena * 1.05  (cena u igri prati ocekivani ucinak; "mudrost gomile")
  ansambl = 0.45*A + 0.35*B + 0.20*C, pa * uloga(minutaza) * faktor_meca
  faktor_meca = (1.03 domacin / 0.97 gost) * (0.94 + 0.12 * verovatnoca_pobede_iz_kvota)

KVOTE: ucinak ~ Normalna(proj, sd = 0.40*proj + 3), plus zajednicki "sok" tima (saigraci su korelisani).
  Za svakog igraca: P(>=20 FP), P(>=30 FP) i fer kvota = 1/P.

TIM: kapiten x2 (podesivo), petorka u formaciji 2-2-1/1-2-2/2-1-2/1-3-1/3-1-1, 6. igrac 100%, klupa 50%.
T1/T2: Monte Carlo - posle T1 vidis rezultate i ponovo slazes postavu: igraci iz T2 mogu da udju
  umesto startera iz T1 koji su podbacili, kapiten moze da se prebaci na igraca iz T2.
  T1 igraci koji su bili na klupi ostaju na klupi (pravilo igre).
  -> tim sa vise T2 igraca na klupi ima "osiguranje" i vecu ocekivanu vrednost.

Pokretanje:  python round_optimizer.py --config round14.json --players round14_players.csv
"""
import argparse, csv, json, os, random
from math import erf, sqrt

HERE = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser()
ap.add_argument("--config", default=os.path.join(HERE, "round14.json"))
ap.add_argument("--players", default=os.path.join(HERE, "round14_players.csv"))
ap.add_argument("--sims", type=int, default=3000, help="simulacija za finalnu ocenu")
ap.add_argument("--screen-sims", type=int, default=600, help="simulacija za rangiranje kandidata")
ap.add_argument("--beam", type=int, default=120)
args = ap.parse_args()

cfg = json.load(open(args.config))
FIX = cfg["fixtures"]
CAP = cfg.get("captain_multiplier", 2.0)
FORMATIONS = [(2, 2, 1), (1, 2, 2), (2, 1, 2), (1, 3, 1), (3, 1, 1)]
K_SHRINK = 6

# ------------------------------------------------------------------ podaci + projekcija
P = {}
for r in csv.DictReader(open(args.players)):
    for k in ("credits", "season_pir", "recent_pir", "prior_pir", "role"):
        r[k] = float(r[k])
    r["n_games"] = int(r["n_games"])
    r["mine"] = r["mine"] == "1"
    r["known"] = r["credits_known"] == "1"
    fx = FIX[r["team"]]
    r["turn"], r["opp"] = fx["turn"], fx["opp"]
    A = 0.50 * r["recent_pir"] + 0.35 * r["season_pir"] + 0.15 * r["prior_pir"]
    B = ((r["n_games"] * r["season_pir"] + K_SHRINK * r["prior_pir"]) / (r["n_games"] + K_SHRINK)
         + 0.30 * (r["recent_pir"] - r["season_pir"]))
    C = r["credits"] * 1.05
    match = (1.03 if fx["home"] else 0.97) * (0.94 + 0.12 * fx["win"])
    r["A"], r["B"], r["C"] = A, B, C
    r["proj"] = (0.45 * A + 0.35 * B + 0.20 * C) * r["role"] * match
    r["sd"] = 0.40 * r["proj"] + 3
    P[r["name"]] = r


def p_over(r, x):
    z = (x - r["proj"]) / r["sd"]
    return 0.5 * (1 - erf(z / sqrt(2)))


# ------------------------------------------------------------------ postava (brza, egzaktna)
def best_lineup(names, val, fixed_bench=(), cap_pool=None):
    """Za svaku formaciju uzmi najbolje G/F/C u petorku, 6. = najbolji preostali.
    Vraca (vrednost, petorka, sesti, kapiten, formacija)."""
    elig = [n for n in names if n not in fixed_bench]
    bypos = {p: sorted([n for n in elig if P[n]["pos"] == p], key=lambda n: -val[n]) for p in "GFC"}
    best = (-1e18, None, None, None, None)
    tot_all = sum(val[n] for n in names)
    for g, f, c in FORMATIONS:
        if len(bypos["G"]) < g or len(bypos["F"]) < f or len(bypos["C"]) < c:
            continue
        five = bypos["G"][:g] + bypos["F"][:f] + bypos["C"][:c]
        rest = [n for n in elig if n not in five]
        sixth = max(rest, key=lambda n: val[n]) if rest else None
        caps = [n for n in five if cap_pool is None or n in cap_pool]
        if not caps:
            continue
        cap = max(caps, key=lambda n: val[n])
        on = sum(val[n] for n in five) + (val[sixth] if sixth else 0)
        v = on + 0.5 * (tot_all - on) + (CAP - 1) * val[cap]
        if v > best[0]:
            best = (v, five, sixth, cap, (g, f, c))
    return best


def det_value(names):
    return best_lineup(names, {n: P[n]["proj"] for n in names})[0]


def mc_value(names, sims, seed=11):
    """Ocekivani poeni sa korelacijom saigraca i re-optimizacijom postave u pauzi T1->T2."""
    rnd = random.Random(seed)
    proj0 = {n: P[n]["proj"] for n in names}
    _, five, sixth, cap, _ = best_lineup(names, proj0)
    starters = set(five) | ({sixth} if sixth else set())
    teams = {P[n]["team"] for n in names}
    has_t2 = any(P[n]["turn"] == 2 for n in names)
    t2_names = {n for n in names if P[n]["turn"] == 2}
    fixed = tuple(n for n in names if P[n]["turn"] == 1 and n not in starters)
    cap_pool = t2_names | {cap}
    tot, vals = 0.0, []
    for _ in range(sims):
        shock = {t: rnd.gauss(0, 1) for t in teams}
        sc = {n: P[n]["proj"] + P[n]["sd"] * (0.8 * rnd.gauss(0, 1) + 0.6 * shock[P[n]["team"]]) for n in names}
        if has_t2:
            known = {n: (sc[n] if P[n]["turn"] == 1 else P[n]["proj"]) for n in names}
            _, f5, s6, c, _ = best_lineup(names, known, fixed, cap_pool)
            on = set(f5) | ({s6} if s6 else set())
        else:
            on, c = starters, cap
        v = sum(sc[n] for n in on) + 0.5 * sum(sc[n] for n in names if n not in on) + (CAP - 1) * sc[c]
        tot += v
        vals.append(v)
    vals.sort()
    return tot / sims, vals


# ------------------------------------------------------------------ pretraga trejdova
mine = [n for n, r in P.items() if r["mine"]]
cands = [n for n, r in P.items() if not r["mine"]]
budget_players = cfg["budget"] - cfg["head_coach_credits"]
cost = lambda names: sum(P[n]["credits"] for n in names)
start_cost = cost(mine)
budget_players = max(budget_players, start_cost)  # ako su cene procena, ne kazni trenutni tim

frontier = [(det_value(mine), tuple(sorted(mine)), ())]
pool = {frontier[0][1]: frontier[0]}
for depth in range(cfg["max_trades"]):
    nxt = {}
    for _, roster, moves in frontier:
        rs = set(roster)
        brought = {m[1] for m in moves}
        for out in roster:
            if out in brought:
                continue
            for inn in cands:
                if inn in rs or P[inn]["pos"] != P[out]["pos"]:
                    continue
                nr = tuple(sorted((rs - {out}) | {inn}))
                if nr in nxt or nr in pool or cost(nr) > budget_players + 1e-9:
                    continue
                nxt[nr] = (det_value(nr), nr, moves + ((out, inn),))
    if not nxt:
        break
    frontier = sorted(nxt.values(), key=lambda x: -x[0])[:args.beam]
    for item in frontier[:40]:
        pool[item[1]] = item

# rangiranje Monte Karlom (ovde se vidi vrednost T1/T2 balansa)
screen = sorted(pool.values(), key=lambda x: -x[0])[:80]
scored = []
for det, roster, moves in screen:
    m, _ = mc_value(list(roster), args.screen_sims)
    scored.append((m - 0.15 * len(moves), m, det, roster, moves))  # mala kazna za suvisne trejdove
scored.sort(key=lambda x: -x[0])


def net_moves(moves):
    """sazmi lance A->B->C u A->C"""
    out_in = {}
    for o, i in moves:
        src = next((k for k, v in out_in.items() if v == o), o)
        out_in.pop(src, None)
        if src != i:
            out_in[src] = i
    return list(out_in.items())


# ------------------------------------------------------------------ ispis
print(f"=== PROJEKCIJA {cfg['round']}. KOLA (ansambl A/B/C) + KVOTE ===")
print(f"{'igrac':<15}{'tim':<5}{'P':<2}{'T':<3}{'cr':>6}{'A':>6}{'B':>6}{'C':>6}{'PROJ':>7}{'P>=20':>7}{'kv20':>6}{'P>=30':>7}{'kv30':>7}  mec      napomena")
for r in sorted(P.values(), key=lambda r: -r["proj"]):
    p20, p30 = p_over(r, 20), p_over(r, 30)
    cr = f"{r['credits']:.1f}" + ("" if r["known"] else "?")
    print(f"{r['name']:<15}{r['team']:<5}{r['pos']:<2}T{r['turn']:<2}{cr:>6}{r['A']:>6.1f}{r['B']:>6.1f}{r['C']:>6.1f}"
          f"{r['proj']:>7.1f}{p20:>6.0%}{(1/p20 if p20 > 0.005 else 99):>6.1f}{p30:>6.0%}{(1/p30 if p30 > 0.005 else 99):>7.1f}"
          f"  {r['opp']:<8} {'[MOJ] ' if r['mine'] else ''}{r['note']}")


def show(title, roster, moves, sims):
    m, vals = mc_value(list(roster), sims)
    q = lambda p: vals[int(p * (len(vals) - 1))]
    _, five, sixth, cap, form = best_lineup(list(roster), {n: P[n]["proj"] for n in roster})
    bench = [n for n in roster if n not in five and n != sixth]
    t1 = sum(P[n]["turn"] == 1 for n in roster)
    print(f"\n=== {title} ===")
    print(f"ocekivano {m:.1f} FP (bez trenera) | 50%: {q(.25):.0f}-{q(.75):.0f} | 80%: {q(.10):.0f}-{q(.90):.0f} "
          f"| P(150+)={sum(v >= 150 for v in vals)/len(vals):.0%} | T1/T2 igraca: {t1}/{len(roster)-t1}")
    nm = net_moves(moves)
    if nm:
        print(f"trejdovi ({len(nm)}), ostaje {budget_players - cost(roster):.1f} cr:")
        for o, i in nm:
            print(f"   OUT {P[o]['pos']} {o:<14}{P[o]['credits']:>5} ({P[o]['proj']:.1f}, T{P[o]['turn']})  ->  "
                  f"IN {i:<14}{P[i]['credits']:>5} ({P[i]['proj']:.1f}, T{P[i]['turn']})")
    fmt = lambda n: f"{P[n]['pos']} {n} (T{P[n]['turn']}, {P[n]['proj']:.1f})"
    print(f"formacija {form[0]}-{form[1]}-{form[2]}")
    print("   petorka: " + ", ".join(fmt(n) + (" [KAPITEN]" if n == cap else "") for n in sorted(five, key=lambda n: "GFC".index(P[n]["pos"]))))
    print("   6.:      " + fmt(sixth))
    print("   klupa:   " + ", ".join(fmt(n) for n in sorted(bench, key=lambda n: -P[n]["proj"])))
    t2b = [n for n in bench if P[n]["turn"] == 2]
    if t2b:
        print("   osiguranje u pauzi: " + ", ".join(t2b) + " (T2) mogu da udju umesto T1 startera koji podbaci")
    return m


base = show("TRENUTNI TIM", tuple(sorted(mine)), (), args.sims)
_, m_best, _, r_best, mv_best = scored[0]
best = show("NAJBOLJI TIM (preporuka)", r_best, mv_best, args.sims)
print(f"\nDobit: +{best - base:.1f} FP")
# alternativa sa manje trejdova
few = [s for s in scored if 0 < len(net_moves(s[4])) <= 4]
if few and len(net_moves(few[0][4])) < len(net_moves(mv_best)):
    show("ALTERNATIVA (do 4 trejda)", few[0][3], few[0][4], args.sims)
