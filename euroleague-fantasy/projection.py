#!/usr/bin/env python3
"""Projekcija fantasy poena za 12. kolo + optimalni trejdovi (podaci iz web_data.csv)."""
import csv, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from fantasy_trades import best_trades, team_value

BUDGET, HC, MAX_TRADES = 98.0, 8.3, 4
# protivnik u 12. kolu (sa screenshota): domacin +4%, gost -3%, jak protivnik dodatno
OPP = {"OLY": ("@MTA", 0.97), "HTA": ("@KBA", 0.98), "BAY": ("@ZAL", 0.92),
       "MIL": ("vs CZV", 1.04), "RED": ("@MIL", 0.96)}
W_RECENT, W_SEASON, W_PRIOR = 0.50, 0.35, 0.15

def project(r):
    base = W_RECENT * r["recent_pir"] + W_SEASON * r["season_pir"] + W_PRIOR * r["prior_pir"]
    return base * r["role"] * OPP[r["team"]][1]

rows = []
with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "web_data.csv")) as f:
    for r in csv.DictReader(f):
        for k in ("credits", "season_pir", "recent_pir", "prior_pir", "role"):
            r[k] = float(r[k])
        r["mine"] = r["mine"] == "1"; r["known"] = r["credits_known"] == "1"
        r["key"] = r["name"].upper(); r["proj"] = project(r)
        rows.append(r)

print(f"{'igrac':<17}{'tim':<5}{'poz':<4}{'cr':>6}{'proj':>7}{'proj/cr':>8}  sledeci  napomena")
for r in sorted(rows, key=lambda x: -x["proj"]):
    cr = f"{r['credits']:.1f}" + ("" if r["known"] else "?")
    print(f"{r['name']:<17}{r['team']:<5}{r['pos']:<4}{cr:>6}{r['proj']:>7.1f}{r['proj']/r['credits']:>8.2f}  "
          f"{OPP[r['team']][0]:<8} {'[MOJ] ' if r['mine'] else ''}{r['note']}")

proj = {r["key"]: r["proj"] for r in rows}
roster = [dict(key=r["key"], name=r["name"], pos=r["pos"], credits=r["credits"]) for r in rows if r["mine"]]
cands = [dict(key=r["key"], name=r["name"], pos=r["pos"], credits=r["credits"]) for r in rows if not r["mine"]]
res = best_trades(roster, cands, proj, BUDGET, HC, MAX_TRADES, beam=200)
base = res[0][0]
print(f"\nTrenutni tim, projekcija: {base:.1f} FP (kapiten x2, top6 100%, klupa 50%)")
for k in sorted(res)[1:]:
    val, r, moves = res[k]
    left = BUDGET - HC - sum(p["credits"] for p in r)
    print(f"\n{k} trejd(a): {val:.1f} FP (+{val-base:.1f}), ostaje {left:.1f} cr")
    for o, i in moves:
        print(f"   OUT {o['pos']} {o['name']:<16}{o['credits']:>5} cr ({proj[o['key']]:.1f})  ->  IN {i['name']:<13}{i['credits']:>5} cr ({proj[i['key']]:.1f})")
