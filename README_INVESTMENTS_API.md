# 🚀 Sistema Aggiornamento Automatico Prezzi - Guida Utente

## ✨ Novità

Ora puoi aggiornare automaticamente i prezzi dei tuoi investimenti con un solo click! Il sistema si collega a:
- **CoinGecko** per le criptovalute (Bitcoin, Ethereum, ecc.)
- **Yahoo Finance** per azioni, ETF, obbligazioni e fondi comuni

## 📱 Come Usarlo

### 1️⃣ Collega un Ticker al tuo Investimento

#### Metodo A: Durante la Modifica
1. Apri un investimento esistente
2. Click sul bottone ✏️ **Edit** in alto
3. Accanto al campo "Symbol/Ticker" vedrai un bottone **🔍 Search**
4. Click su **Search**
5. Cerca il simbolo (es. "bitcoin", "apple", "AAPL")
6. Seleziona il risultato corretto dalla lista
7. Vedrai l'anteprima del prezzo corrente
8. Click **Save Ticker**

#### Metodo B: Dalla Pagina Dettaglio
1. Apri il dettaglio di un investimento
2. Scorri fino alla sezione **"Automatic Price Updates"**
3. Click sul bottone **Link Ticker**
4. Segui gli stessi passaggi del Metodo A

### 2️⃣ Aggiorna il Prezzo Automaticamente

Dopo aver collegato un ticker:

1. Apri il dettaglio dell'investimento
2. Nella sezione **"Automatic Price Updates"** vedrai:
   - 🔗 "Linked to: BTC" (il tuo ticker)
   - Bottone **🔄 Update from API**
3. Click su **Update from API**
4. Aspetta 1-2 secondi
5. ✅ Prezzo aggiornato automaticamente!

Il nuovo prezzo viene salvato anche nello storico con la nota "Auto-update from API".

## 🎯 Tipi di Investimento Supportati

| Tipo | Supportato | Provider | Esempi Ticker |
|------|------------|----------|---------------|
| 📈 **Stock** | ✅ Sì | Yahoo Finance | AAPL, MSFT, GOOGL |
| 📊 **ETF** | ✅ Sì | Yahoo Finance | SPY, QQQ, VTI |
| ₿ **Crypto** | ✅ Sì | CoinGecko | BTC, ETH, ADA |
| 💰 **Bond** | ✅ Sì | Yahoo Finance | AGG, BND |
| 🏦 **Mutual Fund** | ✅ Sì | Yahoo Finance | VFIAX |
| 🏠 **Real Estate** | ❌ No | - | Aggiornamento manuale |
| 💎 **Commodity** | ❌ No | - | Aggiornamento manuale |
| 📋 **Other** | ❌ No | - | Aggiornamento manuale |

## 💡 Esempi Pratici

### Esempio 1: Bitcoin
```
1. Crea investimento "Bitcoin"
2. Tipo: Cryptocurrency
3. Salva
4. Apri dettaglio → Link Ticker
5. Cerca: "bitcoin"
6. Seleziona: BTC
7. Save Ticker
8. Update from API → Prezzo aggiornato! 🎉
```

### Esempio 2: Apple Stock
```
1. Crea investimento "Apple Inc."
2. Tipo: Stock
3. Salva
4. Apri dettaglio → Link Ticker
5. Cerca: "apple" o "AAPL"
6. Seleziona: AAPL (Apple Inc.)
7. Save Ticker
8. Update from API → Prezzo aggiornato! 🎉
```

### Esempio 3: S&P 500 ETF
```
1. Crea investimento "S&P 500"
2. Tipo: ETF
3. Salva
4. Apri dettaglio → Link Ticker
5. Cerca: "SPY"
6. Seleziona: SPY (SPDR S&P 500 ETF Trust)
7. Save Ticker
8. Update from API → Prezzo aggiornato! 🎉
```

## 🔍 Ricerca Ticker - Consigli

### Per Azioni/ETF (Yahoo Finance)
- **Cerca per nome**: "apple", "microsoft", "tesla"
- **Cerca per simbolo**: "AAPL", "MSFT", "TSLA"
- **Ticker USA**: Simbolo diretto (es. AAPL)
- **Ticker internazionali**: Aggiungi suffisso exchange (es. NESN.SW per Nestlé)

### Per Criptovalute (CoinGecko)
- **Cerca per nome**: "bitcoin", "ethereum", "cardano"
- **Simboli comuni**:
  - Bitcoin → BTC
  - Ethereum → ETH
  - Binance Coin → BNB
  - Cardano → ADA
  - Solana → SOL
  - Polkadot → DOT

## ⚠️ Risoluzione Problemi

### "No ticker linked"
**Problema**: Hai cliccato "Update from API" ma non hai linkato un ticker
**Soluzione**: Segui la procedura "Collega un Ticker" sopra

### "Error fetching price"
**Possibili cause**:
1. ❌ Connessione internet assente
2. ❌ Simbolo ticker errato
3. ❌ API temporaneamente non disponibile

**Soluzioni**:
1. ✅ Controlla la connessione internet
2. ✅ Verifica che il ticker sia corretto
3. ✅ Riprova dopo qualche minuto

### "Automatic Price Updates Not Supported"
**Problema**: Tipo investimento non supportato (es. Real Estate)
**Soluzione**: Usa l'aggiornamento manuale del prezzo (bottone FAB in basso a destra)

### Prezzo diverso dal mercato
**Cause possibili**:
- Differenza di fuso orario
- Mercato chiuso (mostra ultimo prezzo disponibile)
- Exchange diverso

**Nota**: I prezzi mostrati sono informativi e potrebbero non essere in tempo reale

## 🔐 Privacy e Sicurezza

### Cosa viene inviato alle API?
- ✅ Solo il simbolo ticker (es. "BTC", "AAPL")
- ❌ **NESSUN** dato personale
- ❌ **NESSUN** importo del tuo investimento
- ❌ **NESSUNA** informazione sul tuo portafoglio

### Le API sono gratuite?
- ✅ CoinGecko: Gratuita, nessuna registrazione richiesta
- ✅ Yahoo Finance: Gratuita, nessuna registrazione richiesta

### I dati sono sicuri?
- ✅ Tutte le connessioni usano HTTPS
- ✅ Nessuna API key salvata
- ✅ Solo chiamate in tempo reale, nessun tracking

## 📊 Storico Prezzi

Quando aggiorni un prezzo tramite API:
1. Il prezzo corrente dell'investimento viene aggiornato
2. Viene creato un nuovo record nello storico
3. La nota automatica sarà: "Auto-update from API"
4. Puoi vedere tutti gli aggiornamenti nella sezione "Price Updates"
5. Il grafico dello storico si aggiorna automaticamente

## 🎨 Interfaccia Utente

### Indicatori Visivi

**Ticker Linkato**:
```
┌─────────────────────────────────┐
│ ☁️ Automatic Price Updates      │
│ 🔗 Linked to: BTC               │
│                                 │
│ [🔄 Update from API] [✏️ Change]│
└─────────────────────────────────┘
```

**Ticker Non Linkato**:
```
┌─────────────────────────────────┐
│ ☁️ Automatic Price Updates      │
│ Link a ticker to enable...      │
│                                 │
│      [🔗 Link Ticker]           │
└─────────────────────────────────┘
```

### Stati Loading

**Durante Update**:
```
[⏳ Updating...] (bottone disabilitato)
```

**Successo**:
```
✅ Price updated successfully
USD 45,123.45
```

**Errore**:
```
❌ Error fetching price
Cryptocurrency "XYZ" not found
```

## 🚀 Workflow Completo

### Scenario: Aggiungi Bitcoin e aggiorna il prezzo

```
📱 Passo 1: Crea Investimento
   ├─ Nome: "Bitcoin"
   ├─ Tipo: Cryptocurrency
   ├─ Azioni: 0.5
   ├─ Prezzo acquisto: 40000
   └─ ✅ Salva

📱 Passo 2: Link Ticker
   ├─ Apri dettaglio Bitcoin
   ├─ Sezione "Automatic Price Updates"
   ├─ Click "Link Ticker"
   ├─ 🔍 Cerca: "bitcoin"
   ├─ Seleziona: BTC
   ├─ 💰 Anteprima: $45,678.90
   └─ ✅ Save Ticker

📱 Passo 3: Aggiorna Prezzo
   ├─ Torna al dettaglio
   ├─ Vedi: "🔗 Linked to: BTC"
   ├─ Click "🔄 Update from API"
   ├─ Attendi 2 secondi...
   └─ ✅ Prezzo aggiornato a $45,678.90!

📱 Passo 4: Verifica Storico
   ├─ Scorri alla sezione "Price Updates"
   ├─ Vedi nuovo record con:
   │  ├─ Prezzo: $45,678.90
   │  ├─ Data: Oggi
   │  └─ Nota: "Auto-update from API"
   └─ Il grafico si è aggiornato automaticamente
```

## 📈 Vantaggi

✅ **Risparmio tempo**: Aggiorna prezzi con 1 click invece di inserirli manualmente
✅ **Precisione**: Prezzi direttamente dalle fonti ufficiali
✅ **Storico completo**: Ogni aggiornamento salvato automaticamente
✅ **Gratuito**: API pubbliche, nessun costo
✅ **Facile**: Interfaccia intuitiva e guidata
✅ **Multi-asset**: Supporta crypto, azioni, ETF, bond
✅ **Sicuro**: Nessun dato personale condiviso

## 🆘 Supporto

Se hai problemi o domande:
1. Consulta questa guida
2. Verifica la documentazione tecnica in `INVESTMENT_API_INTEGRATION.md`
3. Controlla i log per messaggi di errore specifici

## 📝 Note Importanti

⚠️ **Disclaimer**: I prezzi sono solo informativi e potrebbero non riflettere i prezzi di mercato in tempo reale. Non utilizzare per decisioni di trading critiche.

💡 **Tip**: Per investimenti in Real Estate o Commodity, continua ad usare l'aggiornamento manuale tramite il FAB (bottone +).

🔄 **Frequenza**: Non c'è limite al numero di aggiornamenti, ma usa con moderazione per rispettare i rate limit delle API.

📅 **Mercati chiusi**: Quando i mercati sono chiusi, Yahoo Finance restituisce l'ultimo prezzo disponibile.

---

**Enjoy! 🎉** Ora hai uno strumento potente per tenere traccia dei tuoi investimenti in modo automatico e preciso.
