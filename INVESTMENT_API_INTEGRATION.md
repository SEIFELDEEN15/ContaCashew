# Sistema Aggiornamento Automatico Prezzi Investimenti

## Panoramica

Implementato un sistema completo di aggiornamento automatico dei prezzi degli investimenti tramite API esterne. Il sistema supporta:
- **CoinGecko API** per le criptovalute
- **Yahoo Finance API** per azioni, ETF, obbligazioni e fondi comuni

## Architettura

### 1. Servizio API (`investmentPriceService.dart`)

#### Struttura
```
InvestmentPriceService (Singleton)
├── CoinGeckoProvider (Crypto)
├── YahooFinanceProvider (Stock, ETF, Bond, Mutual Fund)
└── Future providers...
```

#### Funzionalità Principali

**`fetchPrice(symbol, investmentType, currency)`**
- Recupera il prezzo corrente per un simbolo
- Restituisce: prezzo, valuta, timestamp, eventuali errori
- Timeout: 10 secondi per richiesta
- Gestione errori robusta

**`searchSymbol(query, investmentType)`**
- Cerca simboli/ticker in base al tipo di investimento
- Restituisce fino a 10 risultati
- Include nome completo, simbolo, descrizione

**`getProviderForType(investmentType)`**
- Restituisce il provider appropriato per il tipo di investimento
- Null se il tipo non è supportato

### 2. Provider API

#### CoinGecko Provider
- **Endpoint**: `https://api.coingecko.com/api/v3`
- **Supporta**: Criptovalute
- **API Calls**:
  - `/coins/list`: Lista completa criptovalute
  - `/simple/price`: Prezzo corrente per coin ID
- **Note**: Usa coin ID interni, non solo simboli
- **Limite rate**: Gratuito (50 chiamate/minuto)

#### Yahoo Finance Provider
- **Endpoint**: `https://query1.finance.yahoo.com/v8/finance`
- **Supporta**: Stock, ETF, Bond, Mutual Fund
- **API Calls**:
  - `/chart/{symbol}`: Dati prezzo con metadati
  - `/search`: Ricerca simboli
- **Formato Ticker**: Standard (es. AAPL, MSFT, BTC-USD)
- **Limite rate**: Gratuito, rate limit variabile

### 3. Pagina Link Ticker (`linkInvestmentTickerPage.dart`)

#### Funzionalità
1. **Ricerca Simboli**
   - Input di ricerca con bottone
   - Risultati in tempo reale
   - Informazioni dettagliate per ogni risultato

2. **Anteprima Prezzo**
   - Fetch del prezzo corrente quando si seleziona un simbolo
   - Mostra prezzo, valuta e timestamp
   - Indicatore successo/errore

3. **Salvataggio**
   - Salva il ticker nel campo `symbol` dell'investimento
   - Validazione prima del salvataggio
   - Feedback utente con snackbar

4. **UX**
   - Indicatore visivo per simbolo selezionato
   - Loading states per ricerca e fetch prezzo
   - Messaggi d'errore descrittivi
   - Supporta solo tipi investimento compatibili

### 4. Integrazione Pagina Dettaglio (`investmentPage.dart`)

#### Modifiche
- Convertita da `StatelessWidget` a `StatefulWidget`
- Aggiunto metodo `_updatePriceFromAPI()`
- Sezione dedicata "Automatic Price Updates"

#### UI Components

**Quando ticker è linkato:**
- Badge "Linked to: {SYMBOL}"
- Bottone "Update from API" (con loading state)
- Bottone "Change" per modificare ticker

**Quando ticker non è linkato:**
- Messaggio descrittivo
- Bottone "Link Ticker" per aprire pagina ricerca

**Stati:**
- Loading durante update (disabilita bottone)
- Success: mostra prezzo aggiornato in snackbar
- Error: mostra messaggio errore con dettagli

### 5. Integrazione Pagina Modifica (`addInvestmentPage.dart`)

#### Modifiche
- Aggiunto import del servizio API
- Bottone "Search" accanto al campo Symbol
- Visibile solo in modalità edit
- Visibile solo per tipi investimento supportati

#### Flusso
1. Utente apre modifica investimento
2. Se tipo supporta API → mostra bottone "Search"
3. Click → apre `LinkInvestmentTickerPage`
4. Dopo salvataggio → aggiorna campo Symbol automaticamente

## Workflow Utente

### Primo Setup
```
1. Crea nuovo investimento (es. Bitcoin)
2. Seleziona tipo: Cryptocurrency
3. Salva investimento
4. Apri dettaglio investimento
5. Vedi sezione "Automatic Price Updates"
6. Click "Link Ticker"
7. Cerca "bitcoin"
8. Seleziona "BTC" dai risultati
9. Vedi anteprima prezzo
10. Click "Save Ticker"
11. Tornato al dettaglio, ora vedi "Linked to: BTC"
12. Click "Update from API"
13. Prezzo aggiornato automaticamente!
```

### Aggiornamento Successivo
```
1. Apri dettaglio investimento
2. Click "Update from API"
3. Prezzo aggiornato in 1-2 secondi
4. Nuovo record aggiunto allo storico prezzi
```

## Gestione Errori

### Scenari Gestiti

**1. Provider Non Disponibile**
- Mostra: "Automatic Price Updates Not Supported"
- Soluzione: Usa aggiornamento manuale

**2. Ticker Non Trovato**
- Mostra: "Cryptocurrency/Stock not found"
- Soluzione: Verifica simbolo o cerca di nuovo

**3. API Timeout**
- Timeout: 10 secondi
- Mostra: "Error fetching price: TimeoutException"
- Soluzione: Riprova più tardi

**4. Nessun Ticker Linkato**
- Mostra: "No ticker linked - Please link a ticker first"
- Soluzione: Link ticker tramite bottone

**5. Errore Rete**
- Mostra: Messaggio errore specifico
- Soluzione: Verifica connessione internet

## Sicurezza e Privacy

### API Calls
- **Nessuna API Key richiesta** (servizi gratuiti pubblici)
- **Nessun dato personale** inviato alle API
- Solo simboli ticker pubblici
- **HTTPS** obbligatorio per tutte le chiamate

### Rate Limiting
- Timeout per evitare chiamate infinite
- Nessun caching implementato (feature futura)
- Responsabilità utente per numero di aggiornamenti

### Validazione
- Input sanitizzati prima dell'invio
- Controllo tipo investimento
- Validazione prezzi ricevuti

## Miglioramenti Futuri

### 1. Caching Sistema
```dart
class PriceCache {
  Map<String, CachedPrice> _cache;
  Duration ttl = Duration(minutes: 5);

  Future<double?> getPrice(String symbol) {
    // Check cache first
    // If expired, fetch new
  }
}
```

### 2. Aggiornamento Batch
```dart
Future<void> updateAllInvestments() async {
  final investments = await database.getAllInvestments();
  for (var inv in investments) {
    if (inv.symbol != null) {
      await _updatePriceFromAPI(inv);
      await Future.delayed(Duration(seconds: 2)); // Rate limit
    }
  }
}
```

### 3. Background Updates
```dart
// WorkManager per aggiornamenti periodici automatici
void scheduleBackgroundUpdate() {
  Workmanager.registerPeriodicTask(
    "update-prices",
    "updateInvestmentPrices",
    frequency: Duration(hours: 1),
  );
}
```

### 4. Provider Aggiuntivi
- Alpha Vantage (azioni, forex)
- Binance API (crypto in tempo reale)
- IEX Cloud (dati finanziari avanzati)
- Twelve Data (mercati globali)

### 5. Campi Database Dedicati
```dart
// Modificare tabella Investments
Table investmentsTable {
  ...
  string? apiProvider;
  string? apiSymbol;
  datetime? lastPriceUpdate;
  boolean autoUpdateEnabled;
}
```

### 6. Notifiche Variazioni Prezzo
```dart
// Alert quando prezzo varia oltre soglia
if (priceChange > 5%) {
  LocalNotification.show(
    "Price Alert: ${investment.name}",
    "${priceChange}% change detected",
  );
}
```

## Dipendenze

### Aggiunte al `pubspec.yaml`
```yaml
dependencies:
  http: ^1.2.0  # HTTP client per API calls
```

### Import Necessari
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
```

## Testing

### Test Manuali Consigliati

1. **Test CoinGecko**
   - Crea investimento Crypto
   - Cerca "bitcoin", "ethereum", "cardano"
   - Verifica prezzi corretti

2. **Test Yahoo Finance**
   - Crea investimento Stock
   - Cerca "AAPL", "MSFT", "GOOGL"
   - Verifica prezzi di mercato

3. **Test Errori**
   - Cerca simbolo inesistente
   - Disabilita rete
   - Prova tipo investimento non supportato

4. **Test UI**
   - Verifica loading states
   - Verifica messaggi errore
   - Verifica aggiornamento storico prezzi

### Test Automatici (Futuri)
```dart
test('CoinGecko fetches Bitcoin price', () async {
  final service = InvestmentPriceService();
  final result = await service.fetchPrice('BTC', 'crypto');

  expect(result.isSuccess, true);
  expect(result.price, greaterThan(0));
});
```

## Troubleshooting

### Problema: "No ticker linked"
**Soluzione**: Link un ticker tramite la pagina di ricerca

### Problema: "Error fetching price"
**Causa**: API timeout, simbolo errato, o rete assente
**Soluzione**:
1. Verifica connessione internet
2. Controlla che il simbolo sia corretto
3. Riprova dopo qualche minuto

### Problema: "Automatic Price Updates Not Supported"
**Causa**: Tipo investimento non supportato (es. Real Estate, Commodity)
**Soluzione**: Usa aggiornamento manuale prezzi

### Problema: Prezzo aggiornato ma diverso dal mercato
**Causa**: Differenza timezone o exchange
**Soluzione**: Verifica che il simbolo sia corretto per il tuo exchange

## Performance

### Metriche
- **Tempo medio fetch**: 1-3 secondi
- **Timeout**: 10 secondi massimo
- **Banda utilizzata**: ~5-10 KB per richiesta
- **Caching**: Non implementato (ogni fetch è nuovo)

### Ottimizzazioni Implementate
- Timeout su tutte le chiamate HTTP
- Gestione errori senza crash
- UI responsive con loading states
- Cancellazione navigazione senza memory leaks

## Conformità Legale

### Terms of Use
- **CoinGecko**: Free tier, no authentication needed
- **Yahoo Finance**: Personal use, no commercial redistribution

### Disclaimer
I prezzi mostrati sono solo informativi e potrebbero non riflettere i prezzi di mercato in tempo reale. Non utilizzare per decisioni di trading critiche.

### Privacy
Nessun dato utente inviato alle API. Solo ticker pubblici.

## Changelog

### v1.0 (Corrente)
- ✅ Integrazione CoinGecko per crypto
- ✅ Integrazione Yahoo Finance per stock/ETF
- ✅ UI ricerca e link ticker
- ✅ Aggiornamento manuale da API
- ✅ Validazione e gestione errori
- ✅ Traduzioni IT/EN complete

### v1.1 (Pianificata)
- ⏳ Sistema caching prezzi
- ⏳ Aggiornamento batch automatico
- ⏳ Background updates periodici
- ⏳ Notifiche variazioni prezzo
- ⏳ Provider aggiuntivi
