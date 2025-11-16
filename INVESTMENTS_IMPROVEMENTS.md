# Miglioramenti Sezione Investimenti

## Riepilogo Modifiche

### 1. Nuova Pagina: Aggiornamento Prezzo Investimento
**File**: `budget/lib/pages/updateInvestmentPricePage.dart`

- Pagina dedicata per aggiornare il prezzo di un investimento
- Mostra informazioni investimento (nome, simbolo, azioni)
- Selettore prezzo con validazione
- Calcolo automatico della differenza (valore e percentuale)
- Indicatore visivo per aumento/diminuzione
- Selezione data aggiornamento
- Campo note opzionale
- Utilizza componente `SelectAmount` esistente per input numerici

### 2. Miglioramenti Pagina Dettaglio Investimento
**File**: `budget/lib/pages/investmentPage.dart`

#### Aggiunte:
- **FAB (Floating Action Button)** per accesso rapido all'aggiornamento prezzo
- **Grafico Storico Prezzi**: Visualizzazione temporale dell'andamento del prezzo
  - Usa `LineChartWrapper` (componente esistente)
  - Mostra tutti i valori storici ordinati cronologicamente
  - Design coerente con altri grafici dell'app
- **Lista Storico Aggiornamenti Prezzi**:
  - Mostra fino a 50 aggiornamenti più recenti
  - Per ogni voce: prezzo, data, variazione percentuale, note
  - Badge colorati per aumento (verde) o diminuzione (rosso)
  - Design card coerente con il resto dell'app

### 3. File Traduzioni
**File**: `budget/assets/translations/investments_translations.csv`

- 47 nuove chiavi di traduzione per la sezione investimenti
- Traduzioni complete in inglese e italiano
- Pronto per l'aggiunta di altre lingue

## Dettagli Tecnici

### Funzionalità Database Utilizzate
Le seguenti funzioni erano già presenti nel database ma non utilizzate nell'UI:

- `watchInvestmentPriceHistory(investmentPk)`: Stream dello storico prezzi
- `addPriceHistory(priceHistory)`: Aggiunge un record allo storico
- `updateInvestmentPrice(investmentPk, newPrice, date, note)`: Aggiorna prezzo e salva nello storico

### Componenti Riutilizzati
- `SelectAmount`: Per input prezzi (validazione e formattazione automatica)
- `LineChartWrapper`: Per il grafico storico prezzi
- `Tappable`: Per le card interattive
- `TextFont`: Per testo coerente
- `PageFramework`: Struttura pagina standard
- `PopupFramework` + `openBottomSheet`: Per dialoghi modali

### Stile e Coerenza UI
- Tutti i colori utilizzano `getColor(context, ...)` per supporto tema chiaro/scuro
- Border radius coerenti con `getPlatform() == PlatformOS.isIOS ? 0 : 15`
- Padding orizzontale costrained con `getHorizontalPaddingConstrained(context)`
- Icone supportano `appStateSettings["outlinedIcons"]`
- Animazioni con `AnimateFABDelayed` per il FAB

## Icone Categorie Investimento

### Icone PNG Disponibili
Trovate nella directory `/assets/categories/`:

| Tipo Investimento | Icona PNG Suggerita |
|------------------|---------------------|
| Stock | `charts.png` |
| ETF | `charts.png` |
| Crypto | `crypto.png` |
| Bond | `coin.png` o `dollar-coin.png` |
| Real Estate | `house.png` o `home2.png` |
| Commodity | `diamond.png` |
| Mutual Fund | `charts.png` |
| Other | (usa icona Material corrente) |

### Implementazione Attuale
Al momento vengono utilizzate le **Material Icons** che sono già perfettamente funzionanti e coerenti:
- Stock: `Icons.trending_up_rounded`
- ETF: `Icons.assessment_rounded`
- Crypto: `Icons.currency_bitcoin_rounded`
- Bond: `Icons.attach_money_rounded`
- Real Estate: `Icons.home_rounded`
- Commodity: `Icons.diamond_rounded`
- Mutual Fund: `Icons.pie_chart_rounded`
- Other: `Icons.more_horiz_rounded`

### Possibile Implementazione Futura
Per utilizzare icone PNG come le categorie di transazione, si potrebbe:
1. Aggiungere campi `iconName` e `emojiIconName` alla tabella `Investments`
2. Riutilizzare il componente `CategoryIcon` esistente
3. Permettere agli utenti di personalizzare le icone per ogni investimento

## Architettura e Best Practices

### ✅ Punti di Forza
- **Modulare**: Ogni funzionalità è ben separata
- **Riutilizzo componenti**: Massimo utilizzo di widget esistenti
- **Consistenza UI**: Stile uniforme con il resto dell'app
- **Reattività**: Uso di `StreamBuilder` per aggiornamenti in tempo reale
- **Validazione**: Controlli input su tutti i campi numerici
- **Accessibilità**: Tooltip e label descrittivi

### 🔍 Validazioni e Controlli
- Prezzo deve essere > 0
- Data non può essere futura (tramite `showCustomDatePicker`)
- Nome investimento obbligatorio
- Numero azioni > 0

### 📊 Calcoli Implementati
- Valore totale: `shares * currentPrice`
- Guadagno/Perdita: `currentValue - initialValue`
- Percentuale: `(gainLoss / initialValue) * 100`
- Peso portafoglio: `(investmentValue / totalPortfolio) * 100`
- Variazione prezzo: `((newPrice - oldPrice) / oldPrice) * 100`

## Test Consigliati

1. **Creazione investimento**: Verificare che il record iniziale venga salvato nello storico
2. **Aggiornamento prezzo**: Verificare calcoli e salvataggio nello storico
3. **Visualizzazione grafico**: Testare con 1, 2, 5, 10+ aggiornamenti
4. **Temi**: Testare modalità chiara e scura
5. **Responsive**: Testare su diverse dimensioni schermo

## Note Implementazione

### Bug Risolti
- **Filtri pagina investimenti**: Non esisteva una pagina filtri dedicata (come per le transazioni). I filtri sono gestiti inline tramite il PieChart, funzionalità che era già implementata e funzionante.

### Gestione Valori Numerici
Tutti i valori (shares, purchasePrice, currentPrice, newPrice) sono gestiti come `double` (numeri), non come valuta formattata. La formattazione avviene solo nella visualizzazione tramite `convertToMoney()`.

### Storico Prezzi
- Quando si crea un nuovo investimento, viene aggiunto automaticamente un record iniziale nello storico con note "Initial Purchase"
- Quando si aggiorna il prezzo, il nuovo valore viene salvato sia in `Investments.currentPrice` che in `InvestmentPriceHistories`
- Lo storico è ordinato per data decrescente (più recente prima)

## Prossimi Passi Suggeriti

1. **Integrare traduzioni**: Unire `investments_translations.csv` con `translations.csv` principale
2. **Generare traduzioni**: Eseguire lo script di generazione per tutte le lingue
3. **Test end-to-end**: Verificare il flusso completo utente
4. **Documentazione utente**: Aggiungere guide nell'app se necessario
5. **API prezzi**: Considerare integrazione API per aggiornamento automatico prezzi (opzionale)
