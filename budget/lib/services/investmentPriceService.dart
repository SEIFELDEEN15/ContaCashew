import 'dart:convert';
import 'package:http/http.dart' as http;

/// Result of a price fetch operation
class PriceFetchResult {
  final double? price;
  final String? error;
  final DateTime timestamp;
  final String? currency;

  PriceFetchResult({
    this.price,
    this.error,
    required this.timestamp,
    this.currency,
  });

  bool get isSuccess => price != null && error == null;
}

/// Base class for price providers
abstract class PriceProvider {
  String get name;

  /// Fetch current price for a symbol
  Future<PriceFetchResult> fetchPrice(String symbol, {String currency = 'USD'});

  /// Search for symbols/tickers
  Future<List<PriceSearchResult>> searchSymbol(String query);

  /// Check if this provider supports the given investment type
  bool supportsType(String? investmentType);
}

/// Search result from price provider
class PriceSearchResult {
  final String symbol;
  final String name;
  final String? description;
  final String provider;

  PriceSearchResult({
    required this.symbol,
    required this.name,
    this.description,
    required this.provider,
  });
}

/// CoinGecko API provider for cryptocurrencies
class CoinGeckoProvider implements PriceProvider {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  @override
  String get name => 'CoinGecko';

  @override
  bool supportsType(String? investmentType) {
    return investmentType == 'crypto';
  }

  @override
  Future<PriceFetchResult> fetchPrice(String symbol, {String currency = 'USD'}) async {
    try {
      // CoinGecko uses coin IDs, not symbols
      // First, we need to search for the coin ID
      final searchUrl = '$_baseUrl/coins/list';
      final searchResponse = await http.get(Uri.parse(searchUrl)).timeout(
        Duration(seconds: 10),
      );

      if (searchResponse.statusCode != 200) {
        return PriceFetchResult(
          error: 'Failed to fetch coin list: ${searchResponse.statusCode}',
          timestamp: DateTime.now(),
        );
      }

      final List<dynamic> coins = json.decode(searchResponse.body);
      final coin = coins.firstWhere(
        (c) => c['symbol'].toString().toLowerCase() == symbol.toLowerCase(),
        orElse: () => null,
      );

      if (coin == null) {
        return PriceFetchResult(
          error: 'Cryptocurrency "$symbol" not found',
          timestamp: DateTime.now(),
        );
      }

      final coinId = coin['id'];
      final priceUrl = '$_baseUrl/simple/price?ids=$coinId&vs_currencies=${currency.toLowerCase()}';

      final priceResponse = await http.get(Uri.parse(priceUrl)).timeout(
        Duration(seconds: 10),
      );

      if (priceResponse.statusCode != 200) {
        return PriceFetchResult(
          error: 'Failed to fetch price: ${priceResponse.statusCode}',
          timestamp: DateTime.now(),
        );
      }

      final data = json.decode(priceResponse.body);
      final price = data[coinId]?[currency.toLowerCase()];

      if (price == null) {
        return PriceFetchResult(
          error: 'Price not available for this currency',
          timestamp: DateTime.now(),
        );
      }

      return PriceFetchResult(
        price: price.toDouble(),
        timestamp: DateTime.now(),
        currency: currency,
      );
    } catch (e) {
      return PriceFetchResult(
        error: 'Error fetching price: ${e.toString()}',
        timestamp: DateTime.now(),
      );
    }
  }

  @override
  Future<List<PriceSearchResult>> searchSymbol(String query) async {
    try {
      final url = '$_baseUrl/search?query=$query';
      final response = await http.get(Uri.parse(url)).timeout(
        Duration(seconds: 10),
      );

      if (response.statusCode != 200) {
        return [];
      }

      final data = json.decode(response.body);
      final List<dynamic> coins = data['coins'] ?? [];

      return coins.take(10).map((coin) {
        return PriceSearchResult(
          symbol: coin['symbol']?.toString().toUpperCase() ?? '',
          name: coin['name'] ?? '',
          description: coin['id'],
          provider: name,
        );
      }).toList();
    } catch (e) {
      print('Error searching CoinGecko: $e');
      return [];
    }
  }
}

/// Yahoo Finance API provider for stocks, ETFs, etc.
class YahooFinanceProvider implements PriceProvider {
  // Using Yahoo Finance v8 API (free, no key required)
  static const String _baseUrl = 'https://query1.finance.yahoo.com/v8/finance';

  @override
  String get name => 'Yahoo Finance';

  @override
  bool supportsType(String? investmentType) {
    return investmentType == 'stock' ||
           investmentType == 'etf' ||
           investmentType == 'mutual-fund' ||
           investmentType == 'bond';
  }

  @override
  Future<PriceFetchResult> fetchPrice(String symbol, {String currency = 'USD'}) async {
    try {
      final url = '$_baseUrl/chart/$symbol?interval=1d&range=1d';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      ).timeout(
        Duration(seconds: 15),
      );

      if (response.statusCode != 200) {
        return PriceFetchResult(
          error: 'Failed to fetch price: HTTP ${response.statusCode}',
          timestamp: DateTime.now(),
        );
      }

      final data = json.decode(response.body);
      final result = data['chart']?['result'];

      if (result == null || result.isEmpty) {
        return PriceFetchResult(
          error: 'No data available for symbol "$symbol"',
          timestamp: DateTime.now(),
        );
      }

      final meta = result[0]['meta'];
      final price = meta['regularMarketPrice'];
      final quoteCurrency = meta['currency'];

      if (price == null) {
        return PriceFetchResult(
          error: 'Price not available',
          timestamp: DateTime.now(),
        );
      }

      return PriceFetchResult(
        price: price.toDouble(),
        timestamp: DateTime.now(),
        currency: quoteCurrency,
      );
    } catch (e) {
      return PriceFetchResult(
        error: 'Error fetching price: ${e.toString()}',
        timestamp: DateTime.now(),
      );
    }
  }

  @override
  Future<List<PriceSearchResult>> searchSymbol(String query) async {
    try {
      final url = 'https://query1.finance.yahoo.com/v1/finance/search?q=${Uri.encodeComponent(query)}&quotesCount=10';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      ).timeout(
        Duration(seconds: 15),
      );

      if (response.statusCode != 200) {
        print('Error searching Yahoo Finance: HTTP ${response.statusCode}');
        return [];
      }

      final data = json.decode(response.body);
      final List<dynamic> quotes = data['quotes'] ?? [];

      return quotes.where((quote) {
        // Filter to only include stocks, ETFs, mutual funds
        final quoteType = quote['quoteType']?.toString().toLowerCase();
        return quoteType == 'equity' ||
               quoteType == 'etf' ||
               quoteType == 'mutualfund';
      }).take(10).map((quote) {
        return PriceSearchResult(
          symbol: quote['symbol'] ?? '',
          name: quote['longname'] ?? quote['shortname'] ?? '',
          description: quote['exchange'] ?? '',
          provider: name,
        );
      }).toList();
    } catch (e) {
      print('Error searching Yahoo Finance: $e');
      return [];
    }
  }
}

/// Main service for managing investment prices
class InvestmentPriceService {
  static final InvestmentPriceService _instance = InvestmentPriceService._internal();
  factory InvestmentPriceService() => _instance;
  InvestmentPriceService._internal();

  final List<PriceProvider> _providers = [
    CoinGeckoProvider(),
    YahooFinanceProvider(),
  ];

  /// Get the appropriate provider for an investment type
  PriceProvider? getProviderForType(String? investmentType) {
    try {
      return _providers.firstWhere(
        (provider) => provider.supportsType(investmentType),
      );
    } catch (e) {
      return null;
    }
  }

  /// Fetch price for a symbol using the appropriate provider
  Future<PriceFetchResult> fetchPrice(
    String symbol,
    String? investmentType, {
    String currency = 'USD',
  }) async {
    final provider = getProviderForType(investmentType);

    if (provider == null) {
      return PriceFetchResult(
        error: 'No provider available for this investment type',
        timestamp: DateTime.now(),
      );
    }

    return provider.fetchPrice(symbol, currency: currency);
  }

  /// Search for symbols across all providers
  Future<List<PriceSearchResult>> searchSymbol(String query, String? investmentType) async {
    final provider = getProviderForType(investmentType);

    if (provider == null) {
      return [];
    }

    return provider.searchSymbol(query);
  }

  /// Get all providers
  List<PriceProvider> get providers => _providers;
}
