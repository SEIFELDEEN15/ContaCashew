import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/pages/addInvestmentPage.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/struct/investmentTypes.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/framework/pageFramework.dart';
import 'package:budget/widgets/lineGraph.dart';
import 'package:budget/widgets/openBottomSheet.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({
    Key? key,
    required this.investmentPk,
  }) : super(key: key);

  final String investmentPk;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Investment>(
      stream: database.getInvestment(investmentPk),
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
          title: investment.name,
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
          slivers: [
            // Header with icon
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: getHorizontalPaddingConstrained(context),
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: getInvestmentTypeColor(investment.investmentType),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        getInvestmentTypeIcon(investment.investmentType),
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFont(
                            text: investment.name,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            maxLines: 2,
                          ),
                          if (investment.symbol != null)
                            TextFont(
                              text: investment.symbol!,
                              fontSize: 16,
                              textColor: getColor(context, "textLight"),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Current Value Card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: getHorizontalPaddingConstrained(context),
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
                              ? getColor(context, "incomeAmount").withOpacity(0.15)
                              : getColor(context, "expenseAmount").withOpacity(0.15),
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
                  horizontal: getHorizontalPaddingConstrained(context),
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

            // Price History Chart - TODO: Implement watchPriceHistory in database
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsetsDirectional.symmetric(
            //       horizontal: getHorizontalPaddingConstrained(context),
            //       vertical: 10,
            //     ),
            //     child: TextFont(
            //       text: "price-history-coming-soon".tr(),
            //       fontSize: 14,
            //       textColor: getColor(context, "textLight"),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),

            // Holdings Details
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: getHorizontalPaddingConstrained(context),
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
                        "shares".tr(),
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
