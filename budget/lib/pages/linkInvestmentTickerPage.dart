import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/services/investmentPriceService.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/widgets/button.dart';
import 'package:budget/widgets/framework/pageFramework.dart';
import 'package:budget/widgets/globalSnackbar.dart';
import 'package:budget/widgets/openBottomSheet.dart';
import 'package:budget/widgets/openSnackbar.dart';
import 'package:budget/widgets/tappable.dart';
import 'package:budget/widgets/textInput.dart' as BudgetTextInput;
import 'package:budget/widgets/textWidgets.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LinkInvestmentTickerPage extends StatefulWidget {
  const LinkInvestmentTickerPage({
    Key? key,
    required this.investment,
  }) : super(key: key);

  final Investment investment;

  @override
  State<LinkInvestmentTickerPage> createState() =>
      _LinkInvestmentTickerPageState();
}

class _LinkInvestmentTickerPageState extends State<LinkInvestmentTickerPage> {
  late TextEditingController _searchController;
  final InvestmentPriceService _priceService = InvestmentPriceService();

  List<PriceSearchResult> _searchResults = [];
  bool _isSearching = false;
  String? _selectedSymbol;
  PriceFetchResult? _pricePreview;
  bool _isFetchingPreview = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.investment.symbol ?? "",
    );
    _selectedSymbol = widget.investment.symbol;

    // If symbol exists, fetch preview
    if (_selectedSymbol != null && _selectedSymbol!.isNotEmpty) {
      _fetchPricePreview(_selectedSymbol!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchSymbol() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    try {
      final results = await _priceService.searchSymbol(
        query,
        widget.investment.investmentType,
      );

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      openSnackbar(
        SnackbarMessage(
          title: "search-error".tr() + ": ${e.toString()}",
          icon: Icons.error,
        ),
      );
    }
  }

  Future<void> _fetchPricePreview(String symbol) async {
    setState(() {
      _isFetchingPreview = true;
      _pricePreview = null;
    });

    try {
      final result = await _priceService.fetchPrice(
        symbol,
        widget.investment.investmentType,
      );

      setState(() {
        _pricePreview = result;
        _isFetchingPreview = false;
      });
    } catch (e) {
      setState(() {
        _isFetchingPreview = false;
      });
    }
  }

  Future<void> _saveSymbol() async {
    if (_selectedSymbol == null || _selectedSymbol!.isEmpty) {
      openSnackbar(
        SnackbarMessage(
          title: "please-select-symbol".tr(),
          icon: Icons.warning,
        ),
      );
      return;
    }

    try {
      // Update investment with new symbol
      await database.createOrUpdateInvestment(
        InvestmentsCompanion(
          investmentPk: Value(widget.investment.investmentPk),
          symbol: Value(_selectedSymbol),
        ),
        insert: false,
      );

      Navigator.pop(context, true); // Return true to indicate success

      openSnackbar(
        SnackbarMessage(
          title: "ticker-linked".tr(),
          icon: Icons.check,
        ),
      );
    } catch (e) {
      openSnackbar(
        SnackbarMessage(
          title: "error-linking-ticker".tr(),
          icon: Icons.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = _priceService.getProviderForType(
      widget.investment.investmentType,
    );

    if (provider == null) {
      return PageFramework(
        title: "link-ticker".tr(),
        dragDownToDismiss: true,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: getHorizontalPaddingConstrained(context),
                vertical: 20,
              ),
              child: Container(
                padding: EdgeInsetsDirectional.all(20),
                decoration: BoxDecoration(
                  color: getColor(context, "lightDarkAccentHeavyLight"),
                  borderRadius: BorderRadius.circular(
                    getPlatform() == PlatformOS.isIOS ? 0 : 15,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: getColor(context, "textLight"),
                    ),
                    SizedBox(height: 15),
                    TextFont(
                      text: "automatic-price-not-supported".tr(),
                      fontSize: 16,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    TextFont(
                      text: "automatic-price-not-supported-description".tr(),
                      fontSize: 14,
                      textColor: getColor(context, "textLight"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return PageFramework(
      title: "link-ticker".tr(),
      dragDownToDismiss: true,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: getHorizontalPaddingConstrained(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 13),
                // Investment info
                Container(
                  padding: EdgeInsetsDirectional.all(15),
                  decoration: BoxDecoration(
                    color: getColor(context, "lightDarkAccentHeavyLight"),
                    borderRadius: BorderRadius.circular(
                      getPlatform() == PlatformOS.isIOS ? 0 : 15,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFont(
                              text: widget.investment.name,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.source_outlined,
                                  size: 16,
                                  color: getColor(context, "textLight"),
                                ),
                                SizedBox(width: 5),
                                TextFont(
                                  text: provider.name,
                                  fontSize: 14,
                                  textColor: getColor(context, "textLight"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Search box
                Row(
                  children: [
                    Expanded(
                      child: BudgetTextInput.TextInput(
                        labelText: "search-symbol".tr(),
                        icon: Icons.search,
                        controller: _searchController,
                        padding: EdgeInsetsDirectional.zero,
                        onSubmitted: (_) => _searchSymbol(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Button(
                      label: "search".tr(),
                      onTap: _searchSymbol,
                      icon: Icons.search,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Search results
                if (_isSearching)
                  Center(
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (!_isSearching && _searchResults.isNotEmpty) ...[
                  TextFont(
                    text: "search-results".tr(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10),
                  ..._searchResults.map((result) {
                    final isSelected = _selectedSymbol == result.symbol;
                    return Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 7),
                      child: Tappable(
                        onTap: () {
                          setState(() {
                            _selectedSymbol = result.symbol;
                            _searchController.text = result.symbol;
                          });
                          _fetchPricePreview(result.symbol);
                        },
                        color: isSelected
                            ? Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.3)
                            : getColor(context, "lightDarkAccentHeavyLight"),
                        borderRadius:
                            getPlatform() == PlatformOS.isIOS ? 0 : 12,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        TextFont(
                                          text: result.symbol,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        if (isSelected) ...[
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.check_circle,
                                            size: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 3),
                                    TextFont(
                                      text: result.name,
                                      fontSize: 14,
                                      textColor: getColor(context, "textLight"),
                                      maxLines: 2,
                                    ),
                                    if (result.description != null &&
                                        result.description!.isNotEmpty)
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.only(top: 3),
                                        child: TextFont(
                                          text: result.description!,
                                          fontSize: 12,
                                          textColor:
                                              getColor(context, "textLight"),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
                // Price preview
                if (_selectedSymbol != null && _selectedSymbol!.isNotEmpty) ...[
                  SizedBox(height: 20),
                  TextFont(
                    text: "price-preview".tr(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsetsDirectional.all(15),
                    decoration: BoxDecoration(
                      color: getColor(context, "lightDarkAccentHeavyLight"),
                      borderRadius: BorderRadius.circular(
                        getPlatform() == PlatformOS.isIOS ? 0 : 15,
                      ),
                    ),
                    child: _isFetchingPreview
                        ? Center(
                            child: Padding(
                              padding: EdgeInsetsDirectional.all(10),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : _pricePreview != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextFont(
                                        text: _selectedSymbol!,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      if (_pricePreview!.isSuccess)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              size: 16,
                                              color: getColor(
                                                  context, "incomeAmount"),
                                            ),
                                            SizedBox(width: 5),
                                            TextFont(
                                              text: "available".tr(),
                                              fontSize: 12,
                                              textColor: getColor(
                                                  context, "incomeAmount"),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  if (_pricePreview!.isSuccess) ...[
                                    TextFont(
                                      text: "current-price".tr(),
                                      fontSize: 12,
                                      textColor: getColor(context, "textLight"),
                                    ),
                                    SizedBox(height: 5),
                                    TextFont(
                                      text:
                                          "${_pricePreview!.currency ?? 'USD'} ${_pricePreview!.price!.toStringAsFixed(2)}",
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ] else ...[
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 16,
                                          color: getColor(
                                              context, "expenseAmount"),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: TextFont(
                                            text: _pricePreview!.error ??
                                                "error".tr(),
                                            fontSize: 12,
                                            textColor: getColor(
                                                context, "expenseAmount"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              )
                            : Center(
                                child: TextFont(
                                  text: "no-preview-available".tr(),
                                  fontSize: 14,
                                  textColor: getColor(context, "textLight"),
                                ),
                              ),
                  ),
                ],
                SizedBox(height: 25),
                // Save button
                Button(
                  label: "save-ticker".tr(),
                  onTap: _saveSymbol,
                  expandedLayout: true,
                  icon: Icons.link,
                ),
                SizedBox(height: 13),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
