import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/pages/addInvestmentPage.dart';
import 'package:budget/pages/linkInvestmentTickerPage.dart';
import 'package:budget/pages/updateInvestmentPricePage.dart';
import 'package:budget/services/investmentPriceService.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/struct/investmentTypes.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/button.dart';
import 'package:budget/widgets/fab.dart';
import 'package:budget/widgets/fadeIn.dart';
import 'package:budget/widgets/framework/pageFramework.dart';
import 'package:budget/widgets/globalSnackbar.dart';
import 'package:budget/widgets/lineGraph.dart';
import 'package:budget/widgets/openBottomSheet.dart';
import 'package:budget/widgets/openSnackbar.dart';
import 'package:budget/widgets/tappable.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({
    Key? key,
    required this.investmentPk,
  }) : super(key: key);

  final String investmentPk;

  @override
  State<InvestmentPage> createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  final InvestmentPriceService _priceService = InvestmentPriceService();
  bool _isUpdatingPrice = false;

  String _getInvestmentTypeEmoji(String? key) {
    switch (key) {
      case 'stock':
        return "📈";
      case 'etf':
        return "📊";
      case 'crypto':
        return "₿";
      case 'bond':
        return "💰";
      case 'real-estate':
        return "🏠";
      case 'commodity':
        return "💎";
      case 'mutual-fund':
        return "🥧";
      case 'other':
      default:
        return "📌";
    }
  }

  String _getSharesLabel(String? investmentType) {
    switch (investmentType) {
      case 'stock':
      case 'etf':
      case 'mutual-fund':
        return "shares".tr();
      case 'crypto':
      case 'commodity':
        return "amount".tr();
      case 'bond':
        return "units".tr();
      case 'real-estate':
        return "quantity".tr();
      default:
        return "quantity".tr();
    }
  }

  Future<void> _updatePriceFromAPI(Investment investment) async {
    if (investment.symbol == null || investment.symbol!.isEmpty) {
      openSnackbar(
        SnackbarMessage(
          title: "no-ticker-linked".tr(),
          description: "link-ticker-first".tr(),
          icon: Icons.warning,
        ),
      );
      return;
    }

    setState(() {
      _isUpdatingPrice = true;
    });

    try {
      final result = await _priceService.fetchPrice(
        investment.symbol!,
        investment.investmentType,
      );

      if (result.isSuccess && result.price != null) {
        await database.updateInvestmentPrice(
          investmentPk: investment.investmentPk,
          newPrice: result.price!,
          note: "auto-update-from-api".tr(),
        );

        openSnackbar(
          SnackbarMessage(
            title: "price-updated-successfully".tr(),
            description:
                "${result.currency ?? 'USD'} ${result.price!.toStringAsFixed(2)}",
            icon: Icons.check,
          ),
        );
      } else {
        openSnackbar(
          SnackbarMessage(
            title: "error-fetching-price".tr(),
            description: result.error ?? "unknown-error".tr(),
            icon: Icons.error,
          ),
        );
      }
    } catch (e) {
      openSnackbar(
        SnackbarMessage(
          title: "error-fetching-price".tr(),
          description: e.toString(),
          icon: Icons.error,
        ),
      );
    } finally {
      setState(() {
        _isUpdatingPrice = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Investment>(
      stream: database.getInvestment(widget.investmentPk),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        final investment = snapshot.data!;
        final currentValue = investment.shares * investment.currentPrice;
        final initialValue = investment.shares * investment.purchasePrice;
        final gainLoss = currentValue - initialValue;
        final gainLossPercentage =
            initialValue > 0 ? (gainLoss / initialValue) * 100 : 0;
        final isGain = gainLoss >= 0;

        return PageFramework(
          title: _getInvestmentTypeEmoji(investment.investmentType) +
              " " +
              investment.name,
          dragDownToDismiss: true,
          actions: [
            IconButton(
              icon: Icon(
                appStateSettings["outlinedIcons"]
                    ? Icons.edit_outlined
                    : Icons.edit_rounded,
              ),
              onPressed: () {
                pushRoute(
                  context,
                  AddInvestmentPage(
                    investment: investment,
                  ),
                );
              },
            ),
          ],
          floatingActionButton: AnimateFABDelayed(
            fab: FAB(
              tooltip: "update-price".tr(),
              iconData: appStateSettings["outlinedIcons"]
                  ? Icons.price_change_outlined
                  : Icons.price_change_rounded,
              openPage: UpdateInvestmentPricePage(investment: investment),
            ),
          ),
          slivers: [
            // Current Value Card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: getHorizontalPaddingConstrained(context) + 13,
                  vertical: 5,
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
                      TextFont(
                        text: "current-value".tr(),
                        fontSize: 14,
                        textColor: getColor(context, "textLight"),
                      ),
                      SizedBox(height: 8),
                      TextFont(
                        text: convertToMoney(
                          Provider.of<AllWallets>(context),
                          currentValue,
                        ),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isGain
                              ? getColor(context, "incomeAmount")
                                  .withOpacity(0.15)
                              : getColor(context, "expenseAmount")
                                  .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isGain
                                  ? appStateSettings["outlinedIcons"]
                                      ? Icons.trending_up_outlined
                                      : Icons.trending_up_rounded
                                  : appStateSettings["outlinedIcons"]
                                      ? Icons.trending_down_outlined
                                      : Icons.trending_down_rounded,
                              color: isGain
                                  ? getColor(context, "incomeAmount")
                                  : getColor(context, "expenseAmount"),
                            ),
                            SizedBox(width: 8),
                            TextFont(
                              text: (isGain ? "+" : "") +
                                  convertToMoney(
                                    Provider.of<AllWallets>(context),
                                    gainLoss,
                                  ),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              textColor: isGain
                                  ? getColor(context, "incomeAmount")
                                  : getColor(context, "expenseAmount"),
                            ),
                            SizedBox(width: 8),
                            TextFont(
                              text: "(" +
                                  (isGain ? "+" : "") +
                                  gainLossPercentage.toStringAsFixed(2) +
                                  "%)",
                              fontSize: 16,
                              textColor: isGain
                                  ? getColor(context, "incomeAmount")
                                  : getColor(context, "expenseAmount"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Portfolio Percentage
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: getHorizontalPaddingConstrained(context) + 13,
                  vertical: 5,
                ),
                child: StreamBuilder<Map<String, double>>(
                  stream: database.watchPortfolioSummary(),
                  builder: (context, portfolioSnapshot) {
                    if (!portfolioSnapshot.hasData) {
                      return SizedBox.shrink();
                    }
                    final totalPortfolio =
                        portfolioSnapshot.data?['totalValue'] ?? 0;
                    final percentage = totalPortfolio > 0
                        ? (currentValue / totalPortfolio) * 100
                        : 0;

                    return Container(
                      padding: EdgeInsetsDirectional.all(18),
                      decoration: BoxDecoration(
                        color: getColor(context, "lightDarkAccentHeavyLight"),
                        borderRadius: BorderRadius.circular(
                          getPlatform() == PlatformOS.isIOS ? 0 : 15,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFont(
                            text: "portfolio-weight".tr(),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          TextFont(
                            text: percentage.toStringAsFixed(2) + "%",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            textColor: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // API Price Update Section
            if (false) // Nascosto temporaneamente - _priceService.getProviderForType(investment.investmentType) != null
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: getHorizontalPaddingConstrained(context) + 13,
                    vertical: 5,
                  ),
                  child: Container(
                    padding: EdgeInsetsDirectional.all(18),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(
                        getPlatform() == PlatformOS.isIOS ? 0 : 15,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.cloud_sync_outlined,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFont(
                                text: "automatic-price-updates".tr(),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (investment.symbol != null &&
                            investment.symbol!.isNotEmpty) ...[
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.link,
                                size: 16,
                                color: getColor(context, "textLight"),
                              ),
                              SizedBox(width: 5),
                              TextFont(
                                text:
                                    "linked-to".tr() + ": ${investment.symbol}",
                                fontSize: 14,
                                textColor: getColor(context, "textLight"),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Button(
                                  label: _isUpdatingPrice
                                      ? "updating".tr()
                                      : "update-from-api".tr(),
                                  onTap: _isUpdatingPrice
                                      ? () {}
                                      : () => _updatePriceFromAPI(investment),
                                  icon: _isUpdatingPrice ? null : Icons.refresh,
                                  expandedLayout: true,
                                  disabled: _isUpdatingPrice,
                                ),
                              ),
                              SizedBox(width: 10),
                              Button(
                                label: "change".tr(),
                                onTap: () async {
                                  await pushRoute(
                                    context,
                                    LinkInvestmentTickerPage(
                                      investment: investment,
                                    ),
                                  );
                                },
                                icon: Icons.edit_outlined,
                              ),
                            ],
                          ),
                        ] else ...[
                          SizedBox(height: 10),
                          TextFont(
                            text: "no-ticker-linked-description".tr(),
                            fontSize: 14,
                            textColor: getColor(context, "textLight"),
                          ),
                          SizedBox(height: 12),
                          Button(
                            label: "link-ticker".tr(),
                            onTap: () async {
                              await pushRoute(
                                context,
                                LinkInvestmentTickerPage(
                                  investment: investment,
                                ),
                              );
                            },
                            icon: Icons.link,
                            expandedLayout: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

            // Price History Chart
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: getHorizontalPaddingConstrained(context) + 13,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: "price-history".tr(),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 10),
                    StreamBuilder<List<InvestmentPriceHistory>>(
                      stream: database
                          .watchInvestmentPriceHistory(widget.investmentPk),
                      builder: (context, historySnapshot) {
                        if (!historySnapshot.hasData ||
                            historySnapshot.data!.isEmpty) {
                          return Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: getColor(
                                  context, "lightDarkAccentHeavyLight"),
                              borderRadius: BorderRadius.circular(
                                getPlatform() == PlatformOS.isIOS ? 0 : 15,
                              ),
                            ),
                            child: Center(
                              child: TextFont(
                                text: "no-price-history".tr(),
                                textColor: getColor(context, "textLight"),
                              ),
                            ),
                          );
                        }

                        final priceHistory = historySnapshot.data!;

                        // Build points for graph (reverse to show oldest first)
                        final sortedHistory = priceHistory.reversed.toList();
                        List<Pair> points = [];

                        for (int i = 0; i < sortedHistory.length; i++) {
                          points.add(
                            Pair(i.toDouble(), sortedHistory[i].price),
                          );
                        }

                        return Container(
                          height: 250,
                          decoration: BoxDecoration(
                            color:
                                getColor(context, "lightDarkAccentHeavyLight"),
                            borderRadius: BorderRadius.circular(
                              getPlatform() == PlatformOS.isIOS ? 0 : 15,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.all(15),
                            child: LineChartWrapper(
                              points: [points],
                              isCurved: true,
                              amountBefore: 0,
                              endDate: DateTime.now(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Price History List
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: getHorizontalPaddingConstrained(context) + 13,
                  vertical: 10,
                ),
                child: TextFont(
                  text: "price-updates".tr(),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StreamBuilder<List<InvestmentPriceHistory>>(
              stream: database.watchInvestmentPriceHistory(widget.investmentPk,
                  limit: 50),
              builder: (context, historySnapshot) {
                if (!historySnapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                final priceHistory = historySnapshot.data!;

                if (priceHistory.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal:
                            getHorizontalPaddingConstrained(context) + 13,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: getColor(context, "lightDarkAccentHeavyLight"),
                          borderRadius: BorderRadius.circular(
                            getPlatform() == PlatformOS.isIOS ? 0 : 15,
                          ),
                        ),
                        child: Center(
                          child: TextFont(
                            text: "no-price-updates".tr(),
                            textColor: getColor(context, "textLight"),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final historyEntry = priceHistory[index];
                      final previousPrice = index < priceHistory.length - 1
                          ? priceHistory[index + 1].price
                          : null;

                      double? priceDifference;
                      double? percentageChange;
                      bool? isIncrease;

                      if (previousPrice != null && previousPrice > 0) {
                        priceDifference = historyEntry.price - previousPrice;
                        percentageChange =
                            (priceDifference / previousPrice) * 100;
                        isIncrease = priceDifference >= 0;
                      }

                      return Padding(
                        padding: EdgeInsetsDirectional.only(
                          bottom: 7,
                          start: getHorizontalPaddingConstrained(context) + 13,
                          end: getHorizontalPaddingConstrained(context) + 13,
                        ),
                        child: Tappable(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius:
                              getPlatform() == PlatformOS.isIOS ? 7 : 12,
                          child: Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          TextFont(
                                            text: convertToMoney(
                                              Provider.of<AllWallets>(context),
                                              historyEntry.price,
                                            ),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          if (isIncrease != null) ...[
                                            SizedBox(width: 10),
                                            Container(
                                              padding: EdgeInsetsDirectional
                                                  .symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isIncrease
                                                    ? getColor(context,
                                                            "incomeAmount")
                                                        .withOpacity(0.15)
                                                    : getColor(context,
                                                            "expenseAmount")
                                                        .withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    isIncrease
                                                        ? Icons
                                                            .arrow_upward_rounded
                                                        : Icons
                                                            .arrow_downward_rounded,
                                                    size: 12,
                                                    color: isIncrease
                                                        ? getColor(context,
                                                            "incomeAmount")
                                                        : getColor(context,
                                                            "expenseAmount"),
                                                  ),
                                                  SizedBox(width: 3),
                                                  TextFont(
                                                    text: percentageChange!
                                                            .abs()
                                                            .toStringAsFixed(
                                                                1) +
                                                        "%",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    textColor: isIncrease
                                                        ? getColor(context,
                                                            "incomeAmount")
                                                        : getColor(context,
                                                            "expenseAmount"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      TextFont(
                                        text: getWordedDateShort(
                                            historyEntry.date),
                                        fontSize: 14,
                                        textColor:
                                            getColor(context, "textLight"),
                                      ),
                                      if (historyEntry.note != null &&
                                          historyEntry.note!.isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  top: 5),
                                          child: TextFont(
                                            text: historyEntry.note!,
                                            fontSize: 13,
                                            textColor:
                                                getColor(context, "textLight"),
                                            maxLines: 2,
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
                    },
                    childCount: priceHistory.length,
                  ),
                );
              },
            ),

            SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Holdings Details
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: getHorizontalPaddingConstrained(context) + 13,
                  vertical: 5,
                ),
                child: Container(
                  padding: EdgeInsetsDirectional.all(18),
                  decoration: BoxDecoration(
                    color: getColor(context, "lightDarkAccentHeavyLight"),
                    borderRadius: BorderRadius.circular(
                      getPlatform() == PlatformOS.isIOS ? 0 : 15,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFont(
                        text: "holdings-details".tr(),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 16),
                      _buildDetailRow(
                        context,
                        _getSharesLabel(investment.investmentType),
                        investment.shares.toString(),
                      ),
                      _buildDetailRow(
                        context,
                        "purchase-price".tr(),
                        convertToMoney(
                          Provider.of<AllWallets>(context),
                          investment.purchasePrice,
                        ),
                      ),
                      _buildDetailRow(
                        context,
                        "current-price".tr(),
                        convertToMoney(
                          Provider.of<AllWallets>(context),
                          investment.currentPrice,
                        ),
                      ),
                      _buildDetailRow(
                        context,
                        "purchase-date".tr(),
                        getWordedDate(investment.purchaseDate),
                      ),
                      if (investment.note != null) ...[
                        Divider(height: 30),
                        TextFont(
                          text: "note".tr(),
                          fontSize: 14,
                          textColor: getColor(context, "textLight"),
                        ),
                        SizedBox(height: 5),
                        TextFont(
                          text: investment.note!,
                          fontSize: 14,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFont(
            text: label,
            fontSize: 14,
            textColor: getColor(context, "textLight"),
          ),
          TextFont(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
