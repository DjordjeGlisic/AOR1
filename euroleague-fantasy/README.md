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
