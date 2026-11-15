#!/usr/bin/env python3
"""
EuroLeague Fantasy - predlog trejdova.

1. Skida box-score za poslednjih N kola (default 5) sa zvanicnog EuroLeague API-ja
2. Racuna prosecan PIR (Valuation) za igrace iz dozvoljenih timova ("crveni dresovi")
3. (opciono) Pretrazuje fantasy sajtove (RotoWire, euroleaguebasketball.net, Dunkest,
   Eurohoops) i broji koliko puta se svaki igrac pominje u preporukama za kolo
4. Na osnovu roster.json (+ prices.csv sa cenama kandidata) trazi najbolje
   kombinacije do MAX trejdova u okviru budzeta

Pokretanje:
    pip install requests
    python fantasy_trades.py                 # koristi roster.json i prices.csv
    python fantasy_trades.py --rounds 5 --no-web
"""
import argparse
import csv
import html
import json
import os
import re
import sys
import time
import unicodedata
from collections import defaultdict
from itertools import combinations

import requests

API_V2 = "https://api-live.euroleague.net/v2/competitions/E"
BOXSCORE = "https://live.euroleague.net/api/Boxscore"
HEADERS = {"User-Agent": "Mozilla/5.0 (fantasy-helper)"}
HERE = os.path.dirname(os.path.abspath(__file__))

POS_MAP = {"guard": "G", "forward": "F", "center": "C", "centre": "C"}


# ---------------------------------------------------------------- helpers
def norm(s: str) -> str:
    s = unicodedata.normalize("NFKD", s or "").encode("ascii", "ignore").decode()
    return re.sub(r"[^A-Z\- ]", "", s.upper()).strip()


def last_name(full: str) -> str:
    """'VEZENKOV, ALEKSANDER' -> 'VEZENKOV'; 'Codi Miller-McIntyre' -> 'MILLER-MCINTYRE'"""
    full = norm(full) if "," not in full else norm(full.split(",")[0])
    parts = full.replace(" JR", "").split()
    return parts[0] if "," in full or len(parts) == 1 else parts[-1]


def get(url, params=None, tries=3):
    for i in range(tries):
        try:
            r = requests.get(url, params=params, headers=HEADERS, timeout=20)
            if r.status_code == 200:
                return r
        except requests.RequestException:
            pass
        time.sleep(1 + i)
    return None


def minutes_to_float(m):
    if not m or m == "DNP":
        return 0.0
    try:
        mm, ss = str(m).split(":")
        return int(mm) + int(ss) / 60
    except ValueError:
        return 0.0


# ---------------------------------------------------------------- data
def round_games(season, rnd):
    r = get(f"{API_V2}/seasons/E{season}/games", {"roundNumber": rnd})
    if not r:
        return []
    out = []
    for g in r.json().get("data", []):
        out.append({
            "code": g.get("gameCode"),
            "played": g.get("played"),
            "home": (g.get("local") or {}).get("club", {}).get("code"),
            "away": (g.get("road") or {}).get("club", {}).get("code"),
            "home_name": (g.get("local") or {}).get("club", {}).get("name", ""),
            "away_name": (g.get("road") or {}).get("club", {}).get("name", ""),
        })
    return out


def team_allowed(code, name, cfg):
    if code and code.upper() in cfg["allowed_teams"]:
        return True
    n = norm(name)
    return any(k in n for k in cfg["allowed_team_name_keywords"])


def collect_pir(season, rounds, cfg):
    """vraca dict: key -> {name, team, games:[(round, pir, min)]}"""
    players = {}
    for rnd in rounds:
        games = round_games(season, rnd)
        print(f"  kolo {rnd}: {len(games)} utakmica", file=sys.stderr)
        for g in games:
            if not g["played"]:
                continue
            if not (team_allowed(g["home"], g["home_name"], cfg)
                    or team_allowed(g["away"], g["away_name"], cfg)):
                continue
            r = get(BOXSCORE, {"gamecode": g["code"], "seasoncode": f"E{season}"})
            if not r:
                print(f"    ! nema boxscore za game {g['code']}", file=sys.stderr)
                continue
            for team in r.json().get("Stats", []):
                tname = team.get("Team", "")
                for p in team.get("PlayersStats", []):
                    tcode = p.get("Team", "")
                    if not team_allowed(tcode, tname, cfg):
                        continue
                    key = p.get("Player_ID", "").strip() or p.get("Player")
                    rec = players.setdefault(key, {
                        "name": p.get("Player", ""), "team": tcode,
                        "games": [], "pos": None})
                    mins = minutes_to_float(p.get("Minutes"))
                    pir = p.get("Valuation") or 0
                    rec["games"].append((rnd, pir if mins > 0 else 0, mins))
    return players


def club_positions(season, codes):
    """pozicije iz zvanicnih rostera (G/F/C) po prezimenu"""
    pos = {}
    for code in codes:
        r = get(f"{API_V2}/seasons/E{season}/clubs/{code}/people")
        if not r:
            continue
        for item in r.json() if isinstance(r.json(), list) else r.json().get("data", []):
            if item.get("type") not in (None, "J"):
                continue
            person = item.get("person", {})
            p = POS_MAP.get(str(item.get("positionName", "")).lower())
            if p:
                pos[(code, last_name(person.get("name", "")))] = p
    return pos


def next_opponents(season, rnd, cfg):
    opp = {}
    for g in round_games(season, rnd):
        opp[g["home"]] = f"vs {g['away']}"
        opp[g["away"]] = f"@ {g['home']}"
    return opp


def load_prices(path):
    """prices.csv: name,team,pos,credits  (cene kandidata iz fantasy aplikacije)"""
    prices = {}
    if not os.path.exists(path):
        return prices
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            if not row.get("name") or not row.get("credits"):
                continue
            prices[last_name(row["name"])] = {
                "credits": float(row["credits"]),
                "pos": (row.get("pos") or "").strip().upper()[:1] or None,
                "team": (row.get("team") or "").strip().upper(),
            }
    return prices


# ---------------------------------------------------------------- expert picks
SEARCH_QUERIES = [
    "euroleague fantasy challenge round {r} tips",
    "euroleague fantasy challenge picks round {r} rotowire",
    "fanta euroleague round {r} tips dunkest",
]
GOOD_DOMAINS = ("euroleaguebasketball.net", "rotowire.com", "dunkest.com", "eurohoops.net")


def expert_mentions(rnd, names):
    """Broji pominjanja prezimena u clancima sa preporukama za kolo."""
    urls = []
    for q in SEARCH_QUERIES:
        r = get("https://html.duckduckgo.com/html/", {"q": q.format(r=rnd)})
        if not r:
            continue
        for u in re.findall(r'uddg=([^&"]+)', r.text):
            u = requests.utils.unquote(u)
            if any(d in u for d in GOOD_DOMAINS) and str(rnd) in u and u not in urls:
                urls.append(u)
    counts = defaultdict(int)
    used = []
    for u in urls[:8]:
        r = get(u)
        if not r:
            continue
        text = norm(html.unescape(re.sub(r"<[^>]+>", " ", r.text)))
        used.append(u)
        for n in names:
            if len(n) > 3:
                c = len(re.findall(rf"\b{re.escape(n)}\b", text))
                if c:
                    counts[n] += 1  # broj clanaka koji ga pominju
    return counts, used


# ---------------------------------------------------------------- optimizer
def team_value(roster, pir):
    """6 najboljih = 100%, ostali 50%, kapiten (najbolji) x2."""
    vals = sorted((pir.get(p["key"], 0) for p in roster), reverse=True)
    if not vals:
        return 0
    return vals[0] * 2 + sum(vals[1:6]) + 0.5 * sum(vals[6:])


def best_trades(roster, candidates, pir, budget, hc_credits, max_trades, beam=40):
    """beam search: svaki trejd = isti broj pozicije (G za G, F za F, C za C)."""
    spent = lambda r: sum(p["credits"] for p in r) + hc_credits
    start = (team_value(roster, pir), roster, [])
    results = {0: start}
    frontier = [start]
    for k in range(1, max_trades + 1):
        nxt = []
        for _, r, moves in frontier:
            keys = {p["key"] for p in r}
            for i, out in enumerate(r):
                if any(m[1]["key"] == out["key"] for m in moves):
                    continue  # ne izbacuj tek dovedenog
                for c in candidates:
                    if c["key"] in keys or c["pos"] != out["pos"]:
                        continue
                    nr = r[:i] + [c] + r[i + 1:]
                    if spent(nr) > budget + 1e-9:
                        continue
                    nxt.append((team_value(nr, pir), nr, moves + [(out, c)]))
        if not nxt:
            break
        nxt.sort(key=lambda x: -x[0])
        seen, frontier = set(), []
        for item in nxt:
            sig = frozenset(p["key"] for p in item[1])
            if sig in seen:
                continue
            seen.add(sig)
            frontier.append(item)
            if len(frontier) >= beam:
                break
        results[k] = frontier[0]
    return results


# ---------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--roster", default=os.path.join(HERE, "roster.json"))
    ap.add_argument("--prices", default=os.path.join(HERE, "prices.csv"))
    ap.add_argument("--rounds", type=int, default=5, help="koliko poslednjih kola")
    ap.add_argument("--top", type=int, default=12, help="top N po poziciji u ispisu")
    ap.add_argument("--min-games", type=int, default=2)
    ap.add_argument("--no-web", action="store_true", help="preskoci fantasy sajtove")
    args = ap.parse_args()

    cfg = json.load(open(args.roster, encoding="utf-8"))
    cfg["allowed_teams"] = [t.upper() for t in cfg["allowed_teams"]]
    cfg["allowed_team_name_keywords"] = [norm(k) for k in cfg["allowed_team_name_keywords"]]
    season, nr = cfg["season"], cfg["next_round"]
    rounds = list(range(max(1, nr - args.rounds), nr))

    print(f"Skidam box-score za kola {rounds} (sezona E{season})...", file=sys.stderr)
    players = collect_pir(season, rounds, cfg)
    if not players:
        sys.exit("Nema podataka - proveri internet / season / next_round u roster.json")

    teams = sorted({p["team"] for p in players.values()})
    positions = club_positions(season, teams)
    prices = load_prices(args.prices)
    opp = next_opponents(season, nr, cfg)

    # statistika
    table = []
    for key, p in players.items():
        played = [g for g in p["games"] if g[2] > 0]
        ln = last_name(p["name"])
        price = prices.get(ln, {})
        pos = price.get("pos") or positions.get((p["team"], ln))
        avg = sum(g[1] for g in played) / len(played) if played else 0
        last2 = [g[1] for g in sorted(played)[-2:]]
        table.append({
            "key": ln, "name": p["name"], "team": p["team"], "pos": pos or "?",
            "gp": len(played), "avg": avg,
            "min": sum(g[2] for g in played) / len(played) if played else 0,
            "trend": (sum(last2) / len(last2) - avg) if last2 else 0,
            "credits": price.get("credits"),
            "next": opp.get(p["team"], "-"),
        })
    # ako igrac nije odigrao sve utakmice tima, kazni prosek (povreda/DNP)
    team_games = defaultdict(int)
    for p in players.values():
        team_games[p["team"]] = max(team_games[p["team"]], len(p["games"]))
    for t in table:
        t["adj"] = t["avg"] * t["gp"] / max(team_games[t["team"]], 1)

    mentions, sources = ({}, [])
    if not args.no_web:
        print("Pretrazujem fantasy sajtove za preporuke...", file=sys.stderr)
        try:
            mentions, sources = expert_mentions(nr, [t["key"] for t in table])
        except Exception as e:  # noqa
            print(f"  ! pretraga nije uspela: {e}", file=sys.stderr)
    for t in table:
        t["exp"] = mentions.get(t["key"], 0)

    # moj roster
    roster = []
    for p in cfg["players"]:
        ln = last_name(p["name"])
        roster.append({"key": ln, "name": p["name"], "pos": p["pos"], "credits": p["credits"]})
    my_keys = {p["key"] for p in roster}
    pir = {t["key"]: t["adj"] for t in table}

    # ------------- ispis
    print(f"\n=== TVOJ ROSTER (prosek PIR poslednjih {len(rounds)} kola) ===")
    for p in roster:
        t = next((x for x in table if x["key"] == p["key"]), None)
        if t:
            print(f"  {p['pos']} {p['name']:<18} {p['credits']:>5} cr  PIR {t['avg']:5.1f} "
                  f"({t['gp']} ut, {t['min']:4.1f} min) trend {t['trend']:+5.1f}  "
                  f"PIR/cr {t['avg'] / p['credits']:4.2f}  {t['next']}")
        else:
            print(f"  {p['pos']} {p['name']:<18} {p['credits']:>5} cr  -- nije igrao / nije nadjen")

    for pos in ("G", "F", "C", "?"):
        rows = sorted([t for t in table if t["pos"] == pos and t["gp"] >= args.min_games],
                      key=lambda x: -x["avg"])[:args.top]
        if not rows:
            continue
        print(f"\n=== TOP {pos} ===")
        print(f"  {'igrac':<26}{'tim':<5}{'ut':>3}{'min':>6}{'PIR':>6}{'trend':>7}{'cr':>6}{'PIR/cr':>7}{'eksp':>5}  sledeci")
        for t in rows:
            cr = f"{t['credits']:.1f}" if t["credits"] else "  ?"
            ratio = f"{t['avg'] / t['credits']:.2f}" if t["credits"] else "  ?"
            mark = " *" if t["key"] in my_keys else ""
            print(f"  {t['name'][:25]:<26}{t['team']:<5}{t['gp']:>3}{t['min']:>6.1f}{t['avg']:>6.1f}"
                  f"{t['trend']:>+7.1f}{cr:>6}{ratio:>7}{t['exp']:>5}  {t['next']}{mark}")

    if sources:
        print("\nIzvori preporuka:")
        for s in sources:
            print("  -", s)

    # ------------- trejdovi
    cands = [dict(key=t["key"], name=t["name"], pos=t["pos"], credits=t["credits"])
             for t in table if t["credits"] and t["pos"] in "GFC" and t["gp"] >= args.min_games
             and t["key"] not in my_keys]
    if not cands:
        print("\n(!) Za predlog trejdova popuni prices.csv cenama kandidata iz aplikacije "
              "(name,team,pos,credits). Gore imas listu top igraca sa PIR-om.")
        return

    res = best_trades(roster, cands, pir, cfg["budget"], cfg["head_coach"]["credits"], cfg["max_trades"])
    base = res[0][0]
    print(f"\n=== PREDLOZI TREJDOVA (procena fantasy poena: trenutno {base:.1f}) ===")
    for k in sorted(res):
        if k == 0:
            continue
        val, r, moves = res[k]
        left = cfg["budget"] - sum(p["credits"] for p in r) - cfg["head_coach"]["credits"]
        print(f"\n  {k} trejd(a): {val:.1f} (+{val - base:.1f}), ostaje {left:.1f} cr")
        for out, inn in moves:
            print(f"    OUT {out['pos']} {out['name']:<18} ({out['credits']} cr, PIR {pir.get(out['key'], 0):.1f})"
                  f"  ->  IN {inn['name']:<24} ({inn['credits']} cr, PIR {pir.get(inn['key'], 0):.1f})")


if __name__ == "__main__":
    main()
