import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/button.dart';
import 'package:budget/widgets/framework/pageFramework.dart';
import 'package:budget/widgets/framework/popupFramework.dart';
import 'package:budget/widgets/globalSnackbar.dart';
import 'package:budget/widgets/openBottomSheet.dart';
import 'package:budget/widgets/openSnackbar.dart';
import 'package:budget/widgets/selectAmount.dart';
import 'package:budget/widgets/textInput.dart' as BudgetTextInput;
import 'package:budget/widgets/textWidgets.dart';
import 'package:budget/widgets/tappable.dart';
import 'package:budget/widgets/util/showDatePicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateInvestmentPricePage extends StatefulWidget {
  const UpdateInvestmentPricePage({
    Key? key,
    required this.investment,
  }) : super(key: key);

  final Investment investment;

  @override
  State<UpdateInvestmentPricePage> createState() =>
      _UpdateInvestmentPricePageState();
}

class _UpdateInvestmentPricePageState extends State<UpdateInvestmentPricePage> {
  late TextEditingController _noteController;
  double? _newPrice;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _newPrice = widget.investment.currentPrice;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectPrice() async {
    await openBottomSheet(
      context,
      fullSnap: true,
      PopupFramework(
        title: "new-price".tr(),
        hasPadding: false,
        underTitleSpace: false,
        child: SelectAmount(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 18),
          amountPassed: _newPrice?.toString() ?? "",
          setSelectedAmount: (amount, _) {
            setState(() {
              _newPrice = amount;
            });
          },
          next: () {
            Navigator.pop(context);
          },
          nextLabel: "set-amount".tr(),
          walletPkForCurrency: widget.investment.walletFk,
          allowZero: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentValue =
        widget.investment.shares * widget.investment.currentPrice;
    final newValue = (_newPrice ?? 0) * widget.investment.shares;
    final difference = newValue - currentValue;
    final differencePercentage =
        currentValue > 0 ? (difference / currentValue) * 100 : 0;
    final isIncrease = difference >= 0;

    return PageFramework(
      title: "update-price".tr(),
      dragDownToDismiss: true,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: getHorizontalPaddingConstrained(context),
            ),
            child: Column(
              children: [
                SizedBox(height: 13),
                // Investment info
                Container(
                  padding: EdgeInsetsDirectional.all(18),
                  decoration: BoxDecoration(
                    color: getColor(context, "lightDarkAccentHeavyLight"),
                    borderRadius: BorderRadius.circular(
                      getPlatform() == PlatformOS.isIOS ? 0 : 15,
                    ),
                  ),
                  child: Column(
                    children: [
                      TextFont(
                        text: widget.investment.name,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      if (widget.investment.symbol != null)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 5),
                          child: TextFont(
                            text: widget.investment.symbol!,
                            fontSize: 14,
                            textColor: getColor(context, "textLight"),
                          ),
                        ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFont(
                            text: "shares".tr() + ": ",
                            fontSize: 14,
                            textColor: getColor(context, "textLight"),
                          ),
                          TextFont(
                            text: widget.investment.shares.toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Current price
                Container(
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
                        text: "current-price".tr(),
                        fontSize: 16,
                      ),
                      TextFont(
                        text: convertToMoney(
                          Provider.of<AllWallets>(context),
                          widget.investment.currentPrice,
                        ),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                // New price selector
                Tappable(
                  onTap: _selectPrice,
                  borderRadius: 15,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              appStateSettings["outlinedIcons"]
                                  ? Icons.trending_up_outlined
                                  : Icons.trending_up_rounded,
                              size: 25,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            SizedBox(width: 17),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFont(
                                  text: "new-price".tr(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                if (_newPrice != null)
                                  TextFont(
                                    text: convertToMoney(
                                      Provider.of<AllWallets>(context),
                                      _newPrice!,
                                    ),
                                    fontSize: 14,
                                    textColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          appStateSettings["outlinedIcons"]
                              ? Icons.chevron_right_outlined
                              : Icons.chevron_right_rounded,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ],
                    ),
                  ),
                ),
                // Difference indicator
                if (_newPrice != null &&
                    _newPrice != widget.investment.currentPrice)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 15),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isIncrease
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
                            isIncrease
                                ? appStateSettings["outlinedIcons"]
                                    ? Icons.arrow_upward_outlined
                                    : Icons.arrow_upward_rounded
                                : appStateSettings["outlinedIcons"]
                                    ? Icons.arrow_downward_outlined
                                    : Icons.arrow_downward_rounded,
                            color: isIncrease
                                ? getColor(context, "incomeAmount")
                                : getColor(context, "expenseAmount"),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          TextFont(
                            text: (isIncrease ? "+" : "") +
                                convertToMoney(
                                  Provider.of<AllWallets>(context),
                                  difference,
                                ),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            textColor: isIncrease
                                ? getColor(context, "incomeAmount")
                                : getColor(context, "expenseAmount"),
                          ),
                          SizedBox(width: 8),
                          TextFont(
                            text: "(" +
                                (isIncrease ? "+" : "") +
                                differencePercentage.toStringAsFixed(2) +
                                "%)",
                            fontSize: 14,
                            textColor: isIncrease
                                ? getColor(context, "incomeAmount")
                                : getColor(context, "expenseAmount"),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                // Date picker
                Tappable(
                  onTap: () async {
                    final picked = await showCustomDatePicker(
                      context,
                      _date,
                    );
                    if (picked != null) {
                      setState(() => _date = picked);
                    }
                  },
                  borderRadius: 15,
                  color: getColor(context, "lightDarkAccentHeavyLight"),
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              appStateSettings["outlinedIcons"]
                                  ? Icons.calendar_today_outlined
                                  : Icons.calendar_today_rounded,
                              size: 25,
                            ),
                            SizedBox(width: 17),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFont(
                                  text: "date".tr(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                TextFont(
                                  text: getWordedDate(_date),
                                  fontSize: 14,
                                  textColor: getColor(context, "textLight"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          appStateSettings["outlinedIcons"]
                              ? Icons.chevron_right_outlined
                              : Icons.chevron_right_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 7),
                // Note (optional)
                BudgetTextInput.TextInput(
                  labelText: "note".tr() + " (" + "optional".tr() + ")",
                  icon: appStateSettings["outlinedIcons"]
                      ? Icons.note_outlined
                      : Icons.note,
                  controller: _noteController,
                  padding: EdgeInsetsDirectional.zero,
                ),
                SizedBox(height: 25),
                // Save button
                Button(
                  label: "update-price".tr(),
                  onTap: _updatePrice,
                  expandedLayout: true,
                ),
                SizedBox(height: 13),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updatePrice() async {
    if (_newPrice == null || _newPrice! <= 0) {
      openSnackbar(
        SnackbarMessage(
          title: "please-enter-valid-price".tr(),
          icon: Icons.warning,
        ),
      );
      return;
    }

    try {
      await database.updateInvestmentPrice(
        investmentPk: widget.investment.investmentPk,
        newPrice: _newPrice!,
        date: _date,
        note: _noteController.text.trim().isNotEmpty
            ? _noteController.text.trim()
            : null,
      );

      Navigator.pop(context);

      openSnackbar(
        SnackbarMessage(
          title: "price-updated".tr(),
          icon: Icons.check,
        ),
      );
    } catch (e) {
      openSnackbar(
        SnackbarMessage(
          title: "error-updating-price".tr(),
          icon: Icons.error,
        ),
      );
    }
  }
}
