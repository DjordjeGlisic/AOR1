#!/usr/bin/env python3
"""
Projekcija fantasy poena za kolo + optimalni trejdovi, sa terminima (T1/T2).

Model projekcije:
  proj = (0.50*PIR_poslednje + 0.35*PIR_sezona + 0.15*PIR_prosla) * uloga * faktor_protivnika
Vrednost tima (Monte Carlo, 4000 simulacija):
  - svaki igrac dobija slucajan ucinak ~ N(proj, sd = 0.45*proj + 3)
  - T1 se odigra; u pauzi izmedju termina menjas startera iz T1 koji je podbacio
    sa igracem sa klupe koji igra u T2 (ako je ocekivano bolje)
  - kapiten x2, startna petorka + 6. igrac 100%, klupa 50%
Pokretanje:  python projection.py [--spare 2.1]
"""
import argparse, csv, os, random, sys
from itertools import combinations
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from fantasy_trades import best_trades

ap = argparse.ArgumentParser()
ap.add_argument("--data", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "web_data.csv"))
ap.add_argument("--budget", type=float, default=98.0)
ap.add_argument("--spare", type=float, default=2.1, help="slobodni krediti sada")
ap.add_argument("--max-trades", type=int, default=4)
ap.add_argument("--sims", type=int, default=4000)
ap.add_argument("--cap", type=float, default=2.0, help="mnozilac kapitena (2.0 ili 1.5)")
args = ap.parse_args()

# protivnik u 12. kolu (screenshot): domacin +4%, gost -2..-4%, jak protivnik dodatno
OPP = {"OLY": ("@MTA", 0.97), "HTA": ("@KBA", 0.98), "BAY": ("@ZAL", 0.92),
       "MIL": ("vs CZV", 1.04), "RED": ("@MIL", 0.96)}
W_RECENT, W_SEASON, W_PRIOR = 0.50, 0.35, 0.15

rows = []
for r in csv.DictReader(open(args.data)):
    for k in ("credits", "season_pir", "recent_pir", "prior_pir", "role"):
        r[k] = float(r[k])
    r["turn"] = int(r.get("turn") or 1)
    r["mine"] = r["mine"] == "1"; r["known"] = r["credits_known"] == "1"
    r["key"] = r["name"].upper()
    opp = OPP.get(r["team"], ("?", 1.0))
    r["opp"] = opp[0]
    r["proj"] = (W_RECENT * r["recent_pir"] + W_SEASON * r["season_pir"]
                 + W_PRIOR * r["prior_pir"]) * r["role"] * opp[1]
    rows.append(r)
P = {r["key"]: r for r in rows}

FORMATIONS = [(2, 2, 1), (1, 2, 2), (2, 1, 2), (1, 3, 1), (3, 1, 1)]  # G-F-C startne petorke
CAP = args.cap

def best_lineup(pl, val, fixed_bench=frozenset(), cap_pool=None):
    """Optimalna postava: petorka u dozvoljenoj formaciji + 6. igrac (bilo koja poz.) + kapiten iz petorke.
    pl: lista igraca; val: key->poeni; fixed_bench: ne smeju u start/6.;
    cap_pool: dozvoljeni kapiteni (None = bilo ko iz petorke). Vraca (vrednost, petorka, sesti, kapiten, formacija)."""
    best = (-1e9, None, None, None, None)
    elig = [p for p in pl if p["key"] not in fixed_bench]
    for combo in combinations(elig, 5):
        g = sum(p["pos"] == "G" for p in combo); f = sum(p["pos"] == "F" for p in combo)
        form = (g, f, 5 - g - f)
        if form not in FORMATIONS:
            continue
        rest = [p for p in elig if p not in combo]
        sixth = max(rest, key=lambda p: val[p["key"]]) if rest else None
        caps = [p for p in combo if cap_pool is None or p["key"] in cap_pool]
        if not caps:
            continue
        cap = max(caps, key=lambda p: val[p["key"]])
        bench = [p for p in pl if p not in combo and p is not sixth]
        v = (sum(val[p["key"]] for p in combo) + (CAP - 1) * val[cap["key"]]
             + (val[sixth["key"]] if sixth else 0) + 0.5 * sum(val[p["key"]] for p in bench))
        if v > best[0]:
            best = (v, combo, sixth, cap, form)
    return best

def det_value(roster, proj):
    return best_lineup([P[p["key"]] for p in roster], proj)[0]

def mc_value(keys, sims=None, seed=7):
    """Monte Carlo: postava pre kola po projekciji; u pauzi T1->T2 re-optimizacija
    (formacija, kapiten, ulazak T2 igraca sa klupe; T1 igraci sa klupe ostaju na klupi)."""
    sims = sims or args.sims
    rnd = random.Random(seed)
    pl = [P[k] for k in keys]
    proj0 = {p["key"]: p["proj"] for p in pl}
    _, start5, sixth, cap, _ = best_lineup(pl, proj0)
    starters = {p["key"] for p in start5} | ({sixth["key"]} if sixth else set())
    has_t2 = any(p["turn"] == 2 for p in pl)
    total = 0.0
    for _ in range(sims):
        sc = {p["key"]: rnd.gauss(p["proj"], 0.45 * p["proj"] + 3) for p in pl}
        if not has_t2:
            v = (sum(sc[k] for k in starters) + 0.5 * sum(sc[p["key"]] for p in pl if p["key"] not in starters)
                 + (CAP - 1) * sc[cap["key"]])
        else:
            # pauza: T1 rezultati poznati, T2 ocekivani
            known = {p["key"]: (sc[p["key"]] if p["turn"] == 1 else p["proj"]) for p in pl}
            fixed = frozenset(p["key"] for p in pl if p["turn"] == 1 and p["key"] not in starters)
            cap_pool = {p["key"] for p in pl if p["turn"] == 2} | {cap["key"]}
            _, s5, s6, c, _ = best_lineup(pl, known, fixed, cap_pool)
            on = {p["key"] for p in s5} | ({s6["key"]} if s6 else set())
            v = (sum(sc[k] for k in on) + 0.5 * sum(sc[p["key"]] for p in pl if p["key"] not in on)
                 + (CAP - 1) * sc[c["key"]])
        total += v
    return total / sims

def lineup_str(keys):
    pl = [P[k] for k in keys]
    _, s5, s6, cap, form = best_lineup(pl, {p["key"]: p["proj"] for p in pl})
    bench = [p for p in pl if p not in s5 and p is not s6]
    return (f"formacija {form[0]}-{form[1]}-{form[2]} | start: "
            + ", ".join(f"{p['pos']} {p['name']}{' (C)' if p is cap else ''}" for p in sorted(s5, key=lambda p: 'GFC'.index(p['pos'])))
            + f" | 6.: {s6['pos']} {s6['name']} | klupa: " + ", ".join(p["name"] for p in bench))

# ---------- tabela
print(f"{'igrac':<17}{'tim':<5}{'poz':<4}{'T':<3}{'cr':>6}{'proj':>7}{'proj/cr':>8}  sledeci  napomena")
for r in sorted(rows, key=lambda x: -x["proj"]):
    cr = f"{r['credits']:.1f}" + ("" if r["known"] else "?")
    print(f"{r['name']:<17}{r['team']:<5}{r['pos']:<4}T{r['turn']:<2}{cr:>6}{r['proj']:>7.1f}"
          f"{r['proj']/r['credits']:>8.2f}  {r['opp']:<8} {'[MOJ] ' if r['mine'] else ''}{r['note']}")

# ---------- trejdovi (beam po deterministickoj vrednosti, pa re-rang Monte Carlom)
proj = {r["key"]: r["proj"] for r in rows}
roster = [dict(key=r["key"], name=r["name"], pos=r["pos"], credits=r["credits"]) for r in rows if r["mine"]]
cands = [dict(key=r["key"], name=r["name"], pos=r["pos"], credits=r["credits"]) for r in rows if not r["mine"]]
spent_players = sum(p["credits"] for p in roster)
hc = args.budget - args.spare - spent_players  # trener + ostalo
base_mc = mc_value([p["key"] for p in roster])
print(f"\nSlobodno: {args.spare:.1f} cr | trenutni tim (Monte Carlo): {base_mc:.1f} FP")
print("   " + lineup_str([p["key"] for p in roster]))

import fantasy_trades as ft
ft.team_value = det_value  # isto pravilo kao gore

def top_options(k, n=15):
    """Sve kombinacije za k trejdova iz beam pretrage, rangirane Monte Carlom."""
    res = best_trades(roster, cands, proj, args.budget, hc, k, beam=300)
    return res

seen = set()
print("\nNAJBOLJE OPCIJE PO BROJU TREJDOVA (Monte Carlo sa T1/T2 zamenama):")
res = best_trades(roster, cands, proj, args.budget, hc, args.max_trades, beam=300)
for k in sorted(res)[1:]:
    _, r, moves = res[k]
    v = mc_value([p["key"] for p in r])
    left = args.budget - hc - sum(p["credits"] for p in r)
    print(f"\n{k} trejd(a): {v:.1f} FP (+{v-base_mc:.1f}), ostaje {left:.1f} cr")
    for o, i in moves:
        print(f"   OUT {o['pos']} {o['name']:<16}{o['credits']:>5} cr ({proj[o['key']]:.1f}, T{P[o['key']]['turn']})"
              f"  ->  IN {i['name']:<13}{i['credits']:>5} cr ({proj[i['key']]:.1f}, T{P[i['key']]['turn']})")
    print("   " + lineup_str([p["key"] for p in r]))

t2 = [r["name"] for r in rows if r["turn"] == 2]
print("\nIgraci u T2: " + (", ".join(t2) if t2 else
      "NEMA - svi timovi iz baze (OLY, RED, HTA, BAY, MIL) igraju T1 u ovom kolu, pa T2 zamene nisu moguce."))
