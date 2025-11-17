import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/pages/investmentPage.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/categoryIcon.dart';
import 'package:budget/widgets/openBottomSheet.dart';
import 'package:budget/widgets/openContainerNavigation.dart';
import 'package:budget/widgets/tappable.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentEntry extends StatelessWidget {
  const InvestmentEntry({
    Key? key,
    required this.investment,
    this.listID,
    this.selected = false,
    this.onSelected,
    this.useHorizontalPaddingConstrained = true,
  }) : super(key: key);

  final Investment investment;
  final String? listID;
  final bool selected;
  final Function(Investment, bool)? onSelected;
  final bool useHorizontalPaddingConstrained;

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

  @override
  Widget build(BuildContext context) {
    final currentValue = investment.shares * investment.currentPrice;
    final initialValue = investment.shares * investment.purchasePrice;
    final gainLoss = currentValue - initialValue;
    final gainLossPercentage =
        initialValue > 0 ? (gainLoss / initialValue) * 100 : 0;
    final isGain = gainLoss >= 0;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: useHorizontalPaddingConstrained
            ? getHorizontalPaddingConstrained(context) + 13
            : 13,
        end: useHorizontalPaddingConstrained
            ? getHorizontalPaddingConstrained(context) + 13
            : 13,
        bottom: 7,
      ),
      child: OpenContainerNavigation(
        borderRadius: getPlatform() == PlatformOS.isIOS ? 0 : 15,
        closedColor: selected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        openPage: InvestmentPage(investmentPk: investment.investmentPk),
        button: (openContainer) {
          return Tappable(
            onTap: openContainer,
            onLongPress: listID != null
                ? () => onSelected?.call(investment, !selected)
                : null,
            color: selected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : getColor(context, "lightDarkAccentHeavyLight"),
            borderRadius: getPlatform() == PlatformOS.isIOS ? 0 : 15,
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              child: Row(
                children: [
                  // Icon
                  investment.categoryFk != null
                      ? CategoryIcon(
                          categoryPk: investment.categoryFk!,
                          size: 27,
                          sizePadding: 23,
                          margin: EdgeInsetsDirectional.zero,
                          borderRadius: 10,
                          canEditByLongPress: false,
                        )
                      : SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              _getInvestmentTypeEmoji(investment.investmentType),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                  SizedBox(width: 13),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and symbol
                        Row(
                          children: [
                            Flexible(
                              child: TextFont(
                                text: investment.name,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (investment.symbol != null) ...[
                              SizedBox(width: 5),
                              TextFont(
                                text: "(" + investment.symbol! + ")",
                                fontSize: 14,
                                textColor: getColor(context, "textLight"),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 2),
                        // Shares/Quantity
                        TextFont(
                          text: investment.shares.toString() +
                              " " +
                              _getSharesLabel(investment.investmentType),
                          fontSize: 14,
                          textColor: getColor(context, "textLight"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  // Amount and gain/loss
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFont(
                        text: convertToMoney(
                          Provider.of<AllWallets>(context),
                          currentValue,
                        ),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 2),
                      // Gain/Loss with icon
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isGain
                                ? appStateSettings["outlinedIcons"]
                                    ? Icons.arrow_drop_up_outlined
                                    : Icons.arrow_drop_up_rounded
                                : appStateSettings["outlinedIcons"]
                                    ? Icons.arrow_drop_down_outlined
                                    : Icons.arrow_drop_down_rounded,
                            size: 20,
                            color: isGain
                                ? getColor(context, "incomeAmount")
                                : getColor(context, "expenseAmount"),
                          ),
                          TextFont(
                            text: (isGain ? "+" : "") +
                                convertToMoney(
                                  Provider.of<AllWallets>(context),
                                  gainLoss.abs(),
                                ) +
                                " (" +
                                (isGain ? "+" : "") +
                                gainLossPercentage.abs().toStringAsFixed(2) +
                                "%)",
                            fontSize: 14,
                            textColor: isGain
                                ? getColor(context, "incomeAmount")
                                : getColor(context, "expenseAmount"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
