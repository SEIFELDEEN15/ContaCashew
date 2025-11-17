import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/services/investmentPriceService.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/struct/investmentTypes.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/button.dart';
import 'package:budget/widgets/framework/pageFramework.dart';
import 'package:budget/widgets/framework/popupFramework.dart';
import 'package:budget/widgets/globalSnackbar.dart';
import 'package:budget/widgets/openBottomSheet.dart';
import 'package:budget/widgets/openSnackbar.dart';
import 'package:budget/widgets/openPopup.dart';
import 'package:budget/widgets/selectAmount.dart';
import 'package:budget/widgets/textInput.dart' as BudgetTextInput;
import 'package:budget/widgets/textWidgets.dart';
import 'package:budget/widgets/tappable.dart';
import 'package:budget/widgets/util/showDatePicker.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddInvestmentPage extends StatefulWidget {
  const AddInvestmentPage({
    Key? key,
    this.investment,
  }) : super(key: key);

  final Investment? investment;

  @override
  State<AddInvestmentPage> createState() => _AddInvestmentPageState();
}

class _AddInvestmentPageState extends State<AddInvestmentPage> {
  late TextEditingController _nameController;
  late TextEditingController _symbolController;
  late TextEditingController _noteController;

  double? _shares;
  double? _purchasePrice;
  double? _currentPrice;

  DateTime _purchaseDate = DateTime.now();
  String? _selectedWalletPk;
  String? _selectedInvestmentType;

  bool _isEditing = false;

  String _getSharesLabel() {
    switch (_selectedInvestmentType) {
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
  void initState() {
    super.initState();
    _isEditing = widget.investment != null;

    _nameController = TextEditingController(
      text: widget.investment?.name ?? "",
    );
    _symbolController = TextEditingController(
      text: widget.investment?.symbol ?? "",
    );
    _noteController = TextEditingController(
      text: widget.investment?.note ?? "",
    );

    if (_isEditing) {
      _shares = widget.investment!.shares;
      _purchasePrice = widget.investment!.purchasePrice;
      _currentPrice = widget.investment!.currentPrice;
      _purchaseDate = widget.investment!.purchaseDate;
      _selectedWalletPk = widget.investment!.walletFk;
      _selectedInvestmentType = widget.investment!.investmentType;
    } else {
      _selectedWalletPk = "0";
      _selectedInvestmentType = 'stock'; // Default to stock
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectShares() async {
    await openBottomSheet(
      context,
      fullSnap: true,
      PopupFramework(
        title: _getSharesLabel(),
        hasPadding: false,
        underTitleSpace: false,
        child: SelectAmount(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 18),
          amountPassed: _shares?.toString() ?? "",
          setSelectedAmount: (amount, _) {
            setState(() {
              _shares = amount;
            });
          },
          next: () {
            Navigator.pop(context);
          },
          nextLabel: "set-amount".tr(),
          enableWalletPicker: false,
          allowZero: false,
          convertToMoney: false, // Non mostrare valuta per le azioni
        ),
      ),
    );
  }

  Future<void> _selectPurchasePrice() async {
    await openBottomSheet(
      context,
      fullSnap: true,
      PopupFramework(
        title: "purchase-price".tr(),
        hasPadding: false,
        underTitleSpace: false,
        child: SelectAmount(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 18),
          amountPassed: _purchasePrice?.toString() ?? "",
          setSelectedAmount: (amount, _) {
            setState(() {
              _purchasePrice = amount;
            });
          },
          next: () {
            Navigator.pop(context);
          },
          nextLabel: "set-amount".tr(),
          walletPkForCurrency: _selectedWalletPk,
          allowZero: false,
        ),
      ),
    );
  }

  Future<void> _selectCurrentPrice() async {
    await openBottomSheet(
      context,
      fullSnap: true,
      PopupFramework(
        title: "current-price".tr(),
        hasPadding: false,
        underTitleSpace: false,
        child: SelectAmount(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 18),
          amountPassed: _currentPrice?.toString() ?? "",
          setSelectedAmount: (amount, _) {
            setState(() {
              _currentPrice = amount;
            });
          },
          next: () {
            Navigator.pop(context);
          },
          nextLabel: "set-amount".tr(),
          walletPkForCurrency: _selectedWalletPk,
          allowZero: false,
        ),
      ),
    );
  }

  Future<void> _searchAndLinkSymbol() async {
    final priceService = InvestmentPriceService();
    final provider = priceService.getProviderForType(_selectedInvestmentType);

    if (provider == null) {
      openSnackbar(
        SnackbarMessage(
          title: "no-provider-available".tr(),
          icon: Icons.warning,
        ),
      );
      return;
    }

    // Search for symbols
    final searchQuery = _symbolController.text.trim().isEmpty
        ? _nameController.text.trim()
        : _symbolController.text.trim();

    if (searchQuery.isEmpty) {
      openSnackbar(
        SnackbarMessage(
          title: "enter-symbol-or-name".tr(),
          icon: Icons.warning,
        ),
      );
      return;
    }

    try {
      final results = await provider.searchSymbol(searchQuery);

      if (results.isEmpty) {
        openSnackbar(
          SnackbarMessage(
            title: "no-results-found".tr(),
            icon: Icons.info,
          ),
        );
        return;
      }

      // Show results in a bottom sheet
      await openBottomSheet(
        context,
        PopupFramework(
          title: "select-symbol".tr(),
          child: Column(
            children: results.map((result) {
              return Tappable(
                onTap: () {
                  setState(() {
                    _symbolController.text = result.symbol;
                  });
                  Navigator.pop(context);
                  openSnackbar(
                    SnackbarMessage(
                      title: "symbol-linked".tr(),
                      description: result.symbol,
                      icon: Icons.check,
                    ),
                  );
                },
                color: getColor(context, "lightDarkAccentHeavyLight"),
                borderRadius: 15,
                child: Padding(
                  padding: EdgeInsetsDirectional.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFont(
                              text: result.symbol,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 3),
                            TextFont(
                              text: result.name,
                              fontSize: 14,
                              textColor: getColor(context, "textLight"),
                            ),
                            if (result.description != null &&
                                result.description!.isNotEmpty)
                              TextFont(
                                text: result.description!,
                                fontSize: 12,
                                textColor: getColor(context, "textLight"),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        appStateSettings["outlinedIcons"]
                            ? Icons.chevron_right_outlined
                            : Icons.chevron_right_rounded,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    } catch (e) {
      openSnackbar(
        SnackbarMessage(
          title: "error-searching".tr(),
          description: e.toString(),
          icon: Icons.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageFramework(
      title: _isEditing ? "edit-investment".tr() : "add-investment".tr(),
      dragDownToDismiss: true,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: getHorizontalPaddingConstrained(context) + 13,
            ),
            child: Column(
              children: [
                SizedBox(height: 13),
                // Name
                BudgetTextInput.TextInput(
                  labelText: "investment-name".tr(),
                  icon: Icons.label_outline,
                  controller: _nameController,
                  autoFocus: !_isEditing,
                  padding: EdgeInsetsDirectional.zero,
                ),
                SizedBox(height: 7),
                // Symbol (optional)
                BudgetTextInput.TextInput(
                  labelText:
                      "symbol-ticker".tr() + " (" + "optional".tr() + ")",
                  icon: Icons.tag_outlined,
                  controller: _symbolController,
                  padding: EdgeInsetsDirectional.zero,
                ),
                // Funzionalità di ricerca ticker temporaneamente nascosta
                // Row(
                //   children: [
                //     Expanded(
                //       child: BudgetTextInput.TextInput(
                //         labelText:
                //             "symbol-ticker".tr() + " (" + "optional".tr() + ")",
                //         icon: Icons.tag_outlined,
                //         controller: _symbolController,
                //         padding: EdgeInsetsDirectional.zero,
                //       ),
                //     ),
                //     if (InvestmentPriceService()
                //                 .getProviderForType(_selectedInvestmentType) !=
                //             null) ...[
                //       SizedBox(width: 10),
                //       Padding(
                //         padding: EdgeInsetsDirectional.only(bottom: 7),
                //         child: Button(
                //           label: "search".tr(),
                //           onTap: () async {
                //             if (_isEditing) {
                //               final result = await pushRoute(
                //                 context,
                //                 LinkInvestmentTickerPage(
                //                   investment: widget.investment!,
                //                 ),
                //               );
                //               if (result == true) {
                //                 // Refresh symbol
                //                 final updated = await database
                //                     .getInvestment(
                //                         widget.investment!.investmentPk)
                //                     .first;
                //                 setState(() {
                //                   _symbolController.text = updated.symbol ?? "";
                //                 });
                //               }
                //             } else {
                //               // For new investments, search for symbols
                //               await _searchAndLinkSymbol();
                //             }
                //           },
                //           icon: Icons.search,
                //         ),
                //       ),
                //     ],
                //   ],
                // ),
                SizedBox(height: 7),
                // Notes (optional)
                BudgetTextInput.TextInput(
                  labelText: "note".tr() + " (" + "optional".tr() + ")",
                  icon: appStateSettings["outlinedIcons"]
                      ? Icons.note_outlined
                      : Icons.note,
                  controller: _noteController,
                  padding: EdgeInsetsDirectional.zero,
                ),
                SizedBox(height: 20),
                // Investment Type Selector
                TextFont(
                  text: "investment-type".tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: getInvestmentTypes().map((type) {
                    final isSelected = _selectedInvestmentType == type.key;
                    return Tappable(
                      onTap: () {
                        setState(() {
                          _selectedInvestmentType = type.key;
                        });
                      },
                      borderRadius: 15,
                      color: isSelected
                          ? type.color.withOpacity(0.2)
                          : getColor(context, "lightDarkAccentHeavyLight"),
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: isSelected
                              ? Border.all(color: type.color, width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              type.icon,
                              size: 20,
                              color: isSelected ? type.color : null,
                            ),
                            SizedBox(width: 8),
                            TextFont(
                              text: type.name,
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              textColor: isSelected ? type.color : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                // Shares
                Tappable(
                  onTap: _selectShares,
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
                                  ? Icons.pie_chart_outline
                                  : Icons.pie_chart_rounded,
                              size: 25,
                            ),
                            SizedBox(width: 17),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFont(
                                  text: _getSharesLabel(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                if (_shares != null)
                                  TextFont(
                                    text: _shares.toString(),
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
                // Purchase Price
                Tappable(
                  onTap: _selectPurchasePrice,
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
                                  ? Icons.attach_money_outlined
                                  : Icons.attach_money,
                              size: 25,
                            ),
                            SizedBox(width: 17),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFont(
                                  text: "purchase-price".tr(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                if (_purchasePrice != null)
                                  TextFont(
                                    text: convertToMoney(
                                      Provider.of<AllWallets>(context),
                                      _purchasePrice!,
                                    ),
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
                // Current Price
                Tappable(
                  onTap: _selectCurrentPrice,
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
                                  ? Icons.trending_up_outlined
                                  : Icons.trending_up_rounded,
                              size: 25,
                            ),
                            SizedBox(width: 17),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFont(
                                  text: "current-price".tr(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                if (_currentPrice != null)
                                  TextFont(
                                    text: convertToMoney(
                                      Provider.of<AllWallets>(context),
                                      _currentPrice!,
                                    ),
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
                // Purchase Date
                Tappable(
                  onTap: () async {
                    final picked = await showCustomDatePicker(
                      context,
                      _purchaseDate,
                    );
                    if (picked != null) {
                      setState(() => _purchaseDate = picked);
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
                                  text: "purchase-date".tr(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                TextFont(
                                  text: getWordedDate(_purchaseDate),
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
                SizedBox(height: 25),
                // Save/Delete Buttons
                Row(
                  children: [
                    if (_isEditing)
                      Expanded(
                        child: Button(
                          label: "delete".tr(),
                          onTap: _deleteInvestment,
                          color: Theme.of(context).colorScheme.error,
                          expandedLayout: true,
                        ),
                      ),
                    if (_isEditing) SizedBox(width: 13),
                    Expanded(
                      child: Button(
                        label: _isEditing
                            ? "save-changes".tr()
                            : "add-investment".tr(),
                        onTap: () async {
                          bool result = await _saveInvestment();
                          if (result) Navigator.pop(context);
                        },
                        expandedLayout: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _saveInvestment() async {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      return false;
    }
    if (_selectedInvestmentType == null) {
      return false;
    }
    if (_shares == null || _shares! <= 0) {
      return false;
    }
    if (_purchasePrice == null || _purchasePrice! < 0) {
      return false;
    }
    if (_currentPrice == null || _currentPrice! < 0) {
      return false;
    }

    final companion = InvestmentsCompanion(
      investmentPk:
          Value(_isEditing ? widget.investment!.investmentPk : uuid.v4()),
      name: Value(_nameController.text.trim()),
      symbol: Value(_symbolController.text.trim().isNotEmpty
          ? _symbolController.text.trim().toUpperCase()
          : null),
      investmentType: Value(_selectedInvestmentType!),
      shares: Value(_shares!),
      purchasePrice: Value(_purchasePrice!),
      currentPrice: Value(_currentPrice!),
      purchaseDate: Value(_purchaseDate),
      walletFk: Value(_selectedWalletPk ?? "0"),
      categoryFk: Value(null),
      colour: Value(getInvestmentTypeColor(_selectedInvestmentType!)
          .value
          .toRadixString(16)
          .padLeft(8, '0')),
      iconName: Value(null),
      emojiIconName: Value(null),
      pinned: Value(false),
      archived: Value(false),
      order: Value(_isEditing ? widget.investment!.order : 0),
      note: Value(_noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null),
      dateTimeModified: Value(DateTime.now()),
      dateCreated:
          Value(_isEditing ? widget.investment!.dateCreated : DateTime.now()),
    );

    await database.createOrUpdateInvestment(
      companion,
      insert: !_isEditing,
    );

    if (!_isEditing) {
      await database.addPriceHistory(
        InvestmentPriceHistoriesCompanion.insert(
          investmentFk: companion.investmentPk.value,
          price: _currentPrice!,
          date: Value(_purchaseDate),
          note: Value("initial-purchase".tr()),
        ),
      );
    }

    return true;
  }

  Future<void> _deleteInvestment() async {
    final confirm = await openPopup(
      context,
      title: "delete-investment".tr(),
      description: "delete-investment-confirmation".tr(),
      icon: Icons.warning,
      onSubmit: () async {
        Navigator.pop(context, true);
      },
      onSubmitLabel: "delete".tr(),
      onCancelLabel: "cancel".tr(),
      onCancel: () {
        Navigator.pop(context, false);
      },
    );

    if (confirm == true) {
      await database.deleteInvestment(widget.investment!.investmentPk);
      openSnackbar(
        SnackbarMessage(
          title: "investment-deleted".tr(),
          icon: Icons.check,
        ),
      );
      Navigator.pop(context);
    }
  }
}
