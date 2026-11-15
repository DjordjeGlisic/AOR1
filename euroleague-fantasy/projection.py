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
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from fantasy_trades import best_trades

ap = argparse.ArgumentParser()
ap.add_argument("--data", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "web_data.csv"))
ap.add_argument("--budget", type=float, default=98.0)
ap.add_argument("--spare", type=float, default=2.1, help="slobodni krediti sada")
ap.add_argument("--max-trades", type=int, default=4)
ap.add_argument("--sims", type=int, default=4000)
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

def det_value(roster, proj):
    v = sorted((proj[p["key"]] for p in roster), reverse=True)
    return v[0] * 2 + sum(v[1:6]) + 0.5 * sum(v[6:])

def mc_value(keys, sims=args.sims, seed=7):
    """Ocekivani poeni sa optimalnim izborom: startnih 6, kapiten, zamene u pauzi T1->T2."""
    rnd = random.Random(seed)
    pl = [P[k] for k in keys]
    # pre kola: 6 startera = najveca projekcija; kapiten = najveca projekcija
    order = sorted(pl, key=lambda p: -p["proj"])
    start, bench = order[:6], order[6:]
    cap = order[0]
    total = 0.0
    for _ in range(sims):
        sc = {p["key"]: rnd.gauss(p["proj"], 0.45 * p["proj"] + 3) for p in pl}
        s, b = list(start), list(bench)
        # pauza: T1 starteri su odigrali; T2 igraci sa klupe mogu da udju
        t2_bench = sorted([p for p in b if p["turn"] == 2], key=lambda p: -p["proj"])
        for inn in t2_bench:
            played = [p for p in s if p["turn"] == 1 and p is not cap]
            if not played:
                break
            worst = min(played, key=lambda p: sc[p["key"]])
            # menjaj ako ocekivani dobitak > 0: (proj_in - sc_worst) - 0.5*(proj_in - sc_worst) ...
            # startni slot 100% vs klupa 50%: dobitak = 0.5*proj_in - 0.5*sc_worst
            if inn["proj"] > sc[worst["key"]]:
                s.remove(worst); b.append(worst); b.remove(inn); s.append(inn)
        # kapiten: ako je T1 kapiten podbacio, a postoji T2 starter, kapiten moze preci na njega
        c = cap
        if cap["turn"] == 1:
            t2s = [p for p in s if p["turn"] == 2]
            if t2s:
                best2 = max(t2s, key=lambda p: p["proj"])
                if best2["proj"] > sc[cap["key"]]:
                    c = best2
        tot = sum(sc[p["key"]] for p in s) + 0.5 * sum(sc[p["key"]] for p in b) + sc[c["key"]]
        total += tot
    return total / sims

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
    order = sorted(r, key=lambda p: -proj[p["key"]])
    print("   start: " + ", ".join(f"{p['name']}{' (C)' if j==0 else ''}" for j, p in enumerate(order[:6]))
          + " | klupa: " + ", ".join(p["name"] for p in order[6:]))

t2 = [r["name"] for r in rows if r["turn"] == 2]
print("\nIgraci u T2: " + (", ".join(t2) if t2 else
      "NEMA - svi timovi iz baze (OLY, RED, HTA, BAY, MIL) igraju T1 u ovom kolu, pa T2 zamene nisu moguce."))
