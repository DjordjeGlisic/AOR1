#!/usr/bin/env python3
"""Projekcija poena trenera: poeni zavise od ishoda i razlike.
Pobeda: <=10 -> +10, 11-20 -> +20, >20 -> +25 (Basketballsphere).
Poraz (pretpostavka, nije potvrdjeno): <=10 -> -10, 11-20 -> -15, >20 -> -20 (Kattash -20 za -23).
Razlika ~ Normalna(mu, 12), mu iz verovatnoce pobede (kladionicarske kvote)."""
from statistics import NormalDist
N = NormalDist()
SD = 12.0
def tiers(lo, hi, mu):
    d = NormalDist(mu, SD)
    return d.cdf(hi) - d.cdf(lo)
def expected(p_win):
    mu = SD * N.inv_cdf(p_win)
    win = 10 * tiers(0, 10, mu) + 20 * tiers(10, 20, mu) + 25 * tiers(20, 999, mu)
    loss = -10 * tiers(-10, 0, mu) - 15 * tiers(-20, -10, mu) - 20 * tiers(-999, -20, mu)
    return win + loss, mu
COACHES = [  # trener, tim, termin, verovatnoca pobede, cena (? = nepoznata)
    ("Navarro (tvoj)", "RED vs VIR", 1, 0.65, "~6.8"),
    ("Bartzokas", "OLY vs HTA", 2, 0.68, "?"),
    ("Martinez", "RMB vs ZAL", 2, 0.67, "?"),
    ("Poeta", "MIL @ ASV", 1, 0.60, "~6.4"),
    ("Gavel", "BAY vs MTA", 1, 0.58, "?"),
    ("Barcelona HC", "BAR vs FEN", 1, 0.55, "?"),
    ("Efes HC", "EFE @ BAS", 2, 0.62, "?"),
]
print(f"{'trener':<16}{'mec':<12}{'T':<3}{'P(pob)':>7}{'ocek. FP':>9}  cena")
for n, m, t, p, c in sorted(COACHES, key=lambda x: -expected(x[3])[0]):
    e, mu = expected(p)
    print(f"{n:<16}{m:<12}T{t:<2}{p:>6.0%}{e:>9.1f}  {c}")
