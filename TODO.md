togli loing googel al momento
pagina investments:

- traduzioni nelle varie pagine investimenti ancora non si vedono ma si vedono solo stringhe
- pagina update-price non ha margin/padding corretti
- nel footer come pagine predefinite impostate al posto di budget ci deve essere investments
- altri migliroamenti per la pagina investimenti che faresti?
- card total-portfolio-value non ha alrgezza ocme altre card! inoltre indica X transazioni e non X investimenti

---

- stile dei record della lista investimenti in pagina investimenti deve avere steso stile della lista delle transazioni in tutte le spese
- togli debug scritta in angolo in alto a destra
- al posto di budget\assets\icon\icon.png usa budget\assets\icon\cashtrack-ico.png come icona, anche come icona app android e ios
- al posto di budget\assets\icon\icon-small.png usa budget\assets\icon\cashtrack-ico-small.png

3. Miglioramenti Suggeriti per Investments 💡
   Ecco alcuni miglioramenti che consiglio:

A. Grafici e Analytics

Aggiungere grafico performance nel tempo (line chart)
Mostrare diversificazione portafoglio (già c'è il pie chart)
Aggiungere filtri per categoria di investimento
B. Funzionalità

Dividendi: tracciare dividendi ricevuti
Export: esportare storico investimenti in CSV/Excel
Notifiche: alert quando un investimento sale/scende del X%
Benchmark: confrontare performance con indici di mercato (S&P500, ecc.)
C. UX/UI

Swipe-to-delete su investment entries
Ordinamento investimenti (per valore, performance, data)
Filtri avanzati (per tipo, performance positiva/negativa)
Aggiungi badge "Top Performer" / "Worst Performer"
D. Dati

Aggiornamento automatico prezzi (già commentato, da riabilitare dopo test)
Storico prezzi con granularità diversa (giornaliero, settimanale, mensile)
Calcolo ROI annualizzato
E. Altre features

Split/Merge investimenti
Categorie custom di investimenti
Tags per investimenti
Note ricche (con allegati/link)

--

budget\lib\pages\investmentsListPage.dart

- il grafico a torta di budget\lib\pages\investmentsListPage.dart deve funzioanre come quello di all-spending
- dopo che clicco per aggiungere un investimento
