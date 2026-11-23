# EuroLeague Fantasy – predlog trejdova

```
pip install requests
python fantasy_trades.py            # poslednjih 5 kola, roster.json + prices.csv
python fantasy_trades.py --no-web   # bez pretrage fantasy sajtova
```

- `roster.json` – tvoj tim, budzet (98), broj trejdova (4), sledece kolo i dozvoljeni timovi
  (OLY, Zvezda=RED, Hapoel=HTA, Bayern=MUN, Milano=MIL, Monaco=MCO – menjaj po potrebi).
- `prices.csv` – cene igraca iz aplikacije (`name,team,pos,credits`). Samo igraci sa cenom
  ulaze u optimizaciju trejdova; tabela PIR-a se ispisuje za sve.
- Podaci: `api-live.euroleague.net` (utakmice po kolu) i `live.euroleague.net/api/Boxscore` (PIR = Valuation).
- Vrednost tima = kapiten x2 + 5 sledecih 100% + klupa 50%; trejd uvek ista pozicija (G/F/C).
  Prosek je korigovan za propustene utakmice (DNP/povreda).

## Optimizator kola (round_optimizer.py)

```
python round_optimizer.py --config round14.json --players round14_players.csv
```
- Projekcija = ansambl: tezinski prosek forme, bajesovsko sazimanje (regresija ka proseku), trzisna cena.
- Faktor meca iz domacinstva i verovatnoce pobede (kladionicarske kvote) u `round14.json`.
- Kvote: P(>=20), P(>=30) i fer kvota po igracu.
- Monte Carlo sa korelacijom saigraca i re-optimizacijom postave izmedju T1 i T2.
- Za novo kolo: kopiraj `round14.json` / `round14_players.csv`, azuriraj termine, kvote, cene i PIR.
