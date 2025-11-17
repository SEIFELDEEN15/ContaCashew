import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/pages/addBudgetPage.dart';
import 'package:budget/pages/addInvestmentPage.dart';
import 'package:budget/pages/homePage/homePageNetWorth.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/struct/investmentTypes.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/animatedExpanded.dart';
import 'package:budget/widgets/button.dart';
import 'package:budget/widgets/fab.dart';
import 'package:budget/widgets/fadeIn.dart';
import 'package:budget/widgets/framework/pageFramework.dart';
import 'package:budget/widgets/framework/popupFramework.dart';
import 'package:budget/widgets/incomeExpenseTabSelector.dart';
import 'package:budget/widgets/investmentEntry.dart';
import 'package:budget/widgets/lineGraph.dart';
import 'package:budget/widgets/navigationSidebar.dart';
import 'package:budget/widgets/openBottomSheet.dart';
import 'package:budget/widgets/periodCyclePicker.dart';
import 'package:budget/widgets/pieChart.dart';
import 'package:budget/widgets/tappable.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:budget/widgets/transactionsAmountBox.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentsListPage extends StatefulWidget {
  const InvestmentsListPage({
    Key? key,
    this.backButton = true,
  }) : super(key: key);

  final bool backButton;

  @override
  InvestmentsListPageState createState() => InvestmentsListPageState();
}

class InvestmentsListPageState extends State<InvestmentsListPage>
    with SingleTickerProviderStateMixin {
  late String listID = "Investments Summary";
  GlobalKey<PageFrameworkState> pageState = GlobalKey();
  GlobalKey<PieChartDisplayState> _pieChartDisplayStateKey = GlobalKey();
  late ScrollController _scrollController = ScrollController();
  late TabController _tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: appStateSettings["investmentsLastPage"] == 1 ? 1 : 0,
  );

  DateTimeRange? selectedDateTimeRange;
  int? selectedDateTimeRangeIndex;
  String? selectedInvestmentType;

  void scrollToTop() {
    pageState.currentState?.scrollToTop();
  }

  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    _tabController.addListener(onTabController);
    super.initState();
  }

  void onTabController() {
    updateSettings(
      "investmentsLastPage",
      _tabController.index == 1 ? 1 : 0,
      updateGlobalState: false,
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(onTabController);
    _tabController.dispose();
    super.dispose();
  }

  void selectPeriod({bool onlyShowCycleOption = false}) async {
    await openBottomSheet(
      context,
      PopupFramework(
        title: "select-period".tr(),
        child: WalletPickerPeriodCycle(
          allWalletsSettingKey: null,
          cycleSettingsExtension: "_investments",
          homePageWidgetDisplay: null,
          onlyShowCycleOption: onlyShowCycleOption,
        ),
      ),
    );
    setState(() {
      selectedDateTimeRange = null;
    });
  }

  void changeSelectedDateRange(int delta) {
    int index = (selectedDateTimeRangeIndex ?? 0) - delta;
    if (selectedDateTimeRangeIndex != null && index >= 0) {
      setState(() {
        selectedDateTimeRangeIndex = index;
        selectedDateTimeRange = getCycleDateTimeRange(
          "_investments",
          currentDate: getDatePastToDetermineBudgetDate(
            index,
            getCustomCycleTempBudget("_investments"),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // History tab with line graph
    List<Widget> historyTabPage = [
      InvestmentsPastPerformanceGraph(
        onEntryTapped: (DateTimeRange tappedRange, int tappedRangeIndex) {
          setState(() {
            if (enableDoubleColumn(context) &&
                tappedRange == selectedDateTimeRange) {
              selectedDateTimeRange = null;
              selectedDateTimeRangeIndex = null;
            } else {
              selectedDateTimeRange = tappedRange;
              selectedDateTimeRangeIndex = tappedRangeIndex;
            }
          });
          Future.delayed(Duration(milliseconds: 100), () {
            _tabController.animateTo(0);
          });
        },
        selectedDateTimeRange: selectedDateTimeRange,
      )
    ];

    // Current tab label
    Widget selectedTabCurrent = SelectedPeriodHeaderLabel(
      color: Theme.of(context).colorScheme.secondaryContainer,
      textColor: Theme.of(context).colorScheme.onSecondaryContainer,
      text: getLabelOfSelectedCustomPeriod("_investments"),
      onTap: () {
        selectPeriod();
      },
      iconData: appStateSettings["outlinedIcons"]
          ? Icons.timelapse_outlined
          : Icons.timelapse_rounded,
    );

    // History tab label
    Widget selectedTabHistory = Builder(builder: (context) {
      String selectedRecurrenceDisplay = "";
      Budget tempBudget = getCustomCycleTempBudget("_investments");
      if (tempBudget.periodLength == 1) {
        selectedRecurrenceDisplay = tempBudget.periodLength.toString() +
            " " +
            nameRecurrence[tempBudget.reoccurrence]
                .toString()
                .toLowerCase()
                .tr()
                .toLowerCase();
      } else {
        selectedRecurrenceDisplay = tempBudget.periodLength.toString() +
            " " +
            namesRecurrence[tempBudget.reoccurrence]
                .toString()
                .toLowerCase()
                .tr()
                .toLowerCase();
      }
      return SelectedPeriodHeaderLabel(
        color: Theme.of(context).colorScheme.secondaryContainer,
        textColor: Theme.of(context).colorScheme.onSecondaryContainer,
        text: selectedRecurrenceDisplay,
        onTap: () {
          selectPeriod(onlyShowCycleOption: true);
        },
        iconData: appStateSettings["outlinedIcons"]
            ? Icons.restart_alt_outlined
            : Icons.restart_alt_rounded,
      );
    });

    String timeRangeString = "";
    if (selectedDateTimeRange != null) {
      String startDateString = getWordedDateShort(selectedDateTimeRange!.start);
      String endDateString = getWordedDateShort(selectedDateTimeRange!.end);
      timeRangeString = startDateString == endDateString
          ? startDateString
          : startDateString + " – " + endDateString;
    }

    Widget Function(VoidCallback onTap) selectedTabPeriodSelected =
        (VoidCallback onTap) => AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: selectedDateTimeRange == null
                  ? Container(
                      key: ValueKey(selectedDateTimeRange),
                    )
                  : SelectedPeriodHeaderLabel(
                      key: ValueKey(selectedDateTimeRange),
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onTertiaryContainer,
                      text: selectedDateTimeRange != null
                          ? timeRangeString
                          : getLabelOfSelectedCustomPeriod("_investments"),
                      onTap: onTap,
                      iconData: appStateSettings["outlinedIcons"]
                          ? Icons.timelapse_outlined
                          : Icons.timelapse_rounded,
                    ),
            );

    Widget clearSelectedPeriodButton = AnimatedSizeSwitcher(
      child: selectedDateTimeRange == null
          ? Container(
              key: ValueKey(1),
            )
          : Padding(
              padding: const EdgeInsetsDirectional.only(start: 7),
              child: ButtonIcon(
                key: ValueKey(2),
                onTap: () {
                  setState(() {
                    selectedDateTimeRange = null;
                  });
                },
                icon: appStateSettings["outlinedIcons"]
                    ? Icons.close_outlined
                    : Icons.close_rounded,
                color: Theme.of(context).colorScheme.tertiaryContainer,
                iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
    );

    // Tab selector header
    Widget tabDateFilterSelectorHeader = Padding(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: getHorizontalPaddingConstrained(context) + 13),
      child: IncomeExpenseTabSelector(
        hasBorderRadius: true,
        onTabChanged: (_) {
          setState(() {});
        },
        initialTabIsIncome: appStateSettings["investmentsLastPage"] == 1,
        showIcons: false,
        tabController: _tabController,
        expenseLabel: "current".tr(),
        incomeLabel: "history".tr(),
        expenseCustomIcon: Icon(
          appStateSettings["outlinedIcons"]
              ? Icons.event_note_outlined
              : Icons.event_note_rounded,
        ),
        incomeCustomIcon: Icon(
          appStateSettings["outlinedIcons"]
              ? Icons.history_outlined
              : Icons.history_rounded,
        ),
        belowWidgetBuilder: (bool selectedHistoryTab) {
          return Padding(
            padding: EdgeInsetsDirectional.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _tabController.animation!,
                    builder: (BuildContext context, Widget? child) {
                      double animationProgress =
                          _tabController.animation?.value ?? 0;
                      return ClipRRect(
                        borderRadius: BorderRadiusDirectional.circular(
                            getPlatform() == PlatformOS.isIOS ? 10 : 15),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            IgnorePointer(
                              ignoring: animationProgress > 0.5,
                              child: Transform.translate(
                                offset: Offset(-animationProgress * 100, 0),
                                child: Opacity(
                                  opacity: 1 - animationProgress,
                                  child: selectedTabCurrent,
                                ),
                              ),
                            ),
                            IgnorePointer(
                              ignoring: animationProgress < 0.5,
                              child: Transform.translate(
                                offset:
                                    Offset((1 - animationProgress) * 100, 0),
                                child: Opacity(
                                  opacity: animationProgress,
                                  child: selectedTabHistory,
                                ),
                              ),
                            ),
                            selectedTabPeriodSelected(() {
                              if (animationProgress > 0.5) {
                                selectPeriod(onlyShowCycleOption: true);
                              } else {
                                selectPeriod(onlyShowCycleOption: false);
                              }
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                clearSelectedPeriodButton,
              ],
            ),
          );
        },
      ),
    );

    // Total portfolio value widget
    Widget totalPortfolioContainer = Padding(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: getHorizontalPaddingConstrained(context) + 13),
      child: StreamBuilder<Map<String, double>>(
        stream: database.watchPortfolioSummary(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          final summary = snapshot.data!;
          final totalValue = summary['totalValue'] ?? 0;
          final gainLoss = summary['gainLoss'] ?? 0;
          final gainLossPercentage = summary['gainLossPercentage'] ?? 0;

          return StreamBuilder<List<Investment>>(
            stream: database.watchAllInvestments(hideArchived: true),
            builder: (context, investmentsSnapshot) {
              final investmentCount = investmentsSnapshot.data?.length ?? 0;

              return Column(
                children: [
                  TransactionsAmountBox(
                    onLongPress: () {
                      selectPeriod();
                    },
                    label: "total-portfolio-value".tr(),
                    getTextColor: (double amount) {
                      return getColor(context, "black");
                    },
                    absolute: false,
                    totalWithCountStream: Stream.value(
                      TotalWithCount(
                        total: totalValue,
                        count: investmentCount,
                      ),
                    ),
                    textColor: getColor(context, "black"),
                    countLabel: "investment".tr(),
                    countLabelPlural: "investments".tr(),
                  ),
                  if (gainLoss != 0)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 8),
                      child: TextFont(
                        text:
                            "${gainLoss >= 0 ? '+' : ''}${convertToMoney(Provider.of<AllWallets>(context), gainLoss)} (${gainLoss >= 0 ? '+' : ''}${gainLossPercentage.toStringAsFixed(2)}%)",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        textColor: gainLoss >= 0
                            ? getColor(context, "incomeAmount")
                            : getColor(context, "expenseAmount"),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );

    // Current tab page content
    List<Widget> currentTabPage = [
      SliverToBoxAdapter(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 13),
              child: totalPortfolioContainer,
            ),
          ],
        ),
      ),
      // Pie Chart Section
      InvestmentsPieChartSection(
        pieChartDisplayStateKey: _pieChartDisplayStateKey,
        selectedInvestmentType: selectedInvestmentType,
        onSelectedInvestmentType: (String? type) {
          setState(() {
            selectedInvestmentType = type;
          });
        },
        selectedDateTimeRange: selectedDateTimeRange,
      ),
      // Investments List
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: getHorizontalPaddingConstrained(context) + 13,
            vertical: 10,
          ),
          child: Text(
            "investments".tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      StreamBuilder<List<Investment>>(
        stream: database.watchAllInvestments(
          hideArchived: true,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          List<Investment> investments = snapshot.data ?? [];

          // Filter by selected type if any
          if (selectedInvestmentType != null && selectedInvestmentType != "-1") {
            investments = investments
                .where((inv) => inv.investmentType == selectedInvestmentType)
                .toList();
          }

          if (investments.isEmpty) {
            return SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    selectedInvestmentType != null
                        ? "no-investments-in-category".tr()
                        : "no-investments".tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final investment = investments[index];
                return InvestmentEntry(
                  investment: investment,
                  listID: listID,
                  useHorizontalPaddingConstrained: true,
                );
              },
              childCount: investments.length,
            ),
          );
        },
      ),
      SliverToBoxAdapter(
        child: SizedBox(height: 20),
      ),
    ];

    return PopScope(
      canPop: true,
      child: PageFramework(
        key: pageState,
        title: "investments".tr(),
        backButton: widget.backButton,
        horizontalPaddingConstrained: false,
        listID: listID,
        dragDownToDismiss: true,
        scrollController: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: tabDateFilterSelectorHeader,
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 5),
          ),
          ..._tabController.index == 0 ? currentTabPage : historyTabPage,
        ],
        floatingActionButton: AnimateFABDelayed(
          fab: AddFAB(
            tooltip: "add-investment".tr(),
            openPage: AddInvestmentPage(),
          ),
        ),
      ),
    );
  }
}

// Pie Chart Section Widget
class InvestmentsPieChartSection extends StatelessWidget {
  const InvestmentsPieChartSection({
    Key? key,
    required this.pieChartDisplayStateKey,
    required this.selectedInvestmentType,
    required this.onSelectedInvestmentType,
    this.selectedDateTimeRange,
  }) : super(key: key);

  final GlobalKey<PieChartDisplayState> pieChartDisplayStateKey;
  final String? selectedInvestmentType;
  final Function(String?) onSelectedInvestmentType;
  final DateTimeRange? selectedDateTimeRange;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Investment>>(
      stream: database.watchAllInvestments(hideArchived: true),
      builder: (context, investmentsSnapshot) {
        if (!investmentsSnapshot.hasData ||
            investmentsSnapshot.data!.isEmpty) {
          return SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final investments = investmentsSnapshot.data!;
        final Map<String?, double> typeTotals = {};

        for (var inv in investments) {
          final value = inv.shares * inv.currentPrice;
          typeTotals[inv.investmentType] =
              (typeTotals[inv.investmentType] ?? 0) + value;
        }

        if (typeTotals.isEmpty) {
          return SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final total = typeTotals.values.fold<double>(0, (a, b) => a + b);

        // Map investment type keys to emoji icons
        String getInvestmentTypeEmoji(String? key) {
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

        List<CategoryWithTotal> pieChartData = typeTotals.entries
            .map((e) => CategoryWithTotal(
                  category: TransactionCategory(
                    categoryPk: e.key ?? "other",
                    name: getInvestmentTypeName(e.key),
                    colour: "#" +
                        getInvestmentTypeColor(e.key)
                            .value
                            .toRadixString(16)
                            .padLeft(8, '0')
                            .substring(2),
                    iconName: "",
                    emojiIconName: getInvestmentTypeEmoji(e.key),
                    dateCreated: DateTime.now(),
                    dateTimeModified: null,
                    order: 0,
                    income: false,
                  ),
                  total: e.value,
                ))
            .toList();

        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: getHorizontalPaddingConstrained(context) + 13,
              vertical: 10,
            ),
            child: Column(
              children: [
                // Pie chart
                SizedBox(height: 20),
                PieChartWrapper(
                  pieChartDisplayStateKey: pieChartDisplayStateKey,
                  data: pieChartData,
                  totalSpent: total,
                  setSelectedCategory: (categoryPk, category) async {
                    if (selectedInvestmentType == categoryPk) {
                      onSelectedInvestmentType(null);
                      pieChartDisplayStateKey.currentState?.setTouchedIndex(-1);
                    } else {
                      onSelectedInvestmentType(categoryPk);
                    }
                  },
                ),
                SizedBox(height: 10),
                // Clear selection button
                if (selectedInvestmentType != null &&
                    selectedInvestmentType != "-1")
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        onSelectedInvestmentType(null);
                        pieChartDisplayStateKey.currentState
                            ?.setTouchedIndex(-1);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            appStateSettings["outlinedIcons"]
                                ? Icons.clear_outlined
                                : Icons.clear_rounded,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          TextFont(
                            text: "clear-selection".tr(),
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                // List of investment types with totals
                ...(selectedInvestmentType != null
                        ? pieChartData.where((c) =>
                            c.category.categoryPk == selectedInvestmentType)
                        : pieChartData)
                    .map((categoryWithTotal) {
                  bool isSelected = selectedInvestmentType ==
                      categoryWithTotal.category.categoryPk;
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 8),
                    child: Tappable(
                      onTap: () {
                        if (isSelected) {
                          onSelectedInvestmentType(null);
                          pieChartDisplayStateKey.currentState
                              ?.setTouchedIndex(-1);
                        } else {
                          onSelectedInvestmentType(
                              categoryWithTotal.category.categoryPk);
                          pieChartDisplayStateKey.currentState
                              ?.setTouchedCategoryPk(
                                  categoryWithTotal.category.categoryPk);
                        }
                      },
                      color: isSelected
                          ? HexColor(categoryWithTotal.category.colour)
                              .withOpacity(0.2)
                          : getColor(context, "lightDarkAccentHeavyLight"),
                      borderRadius: getPlatform() == PlatformOS.isIOS ? 0 : 12,
                      child: Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            // Icon/Emoji
                            if (categoryWithTotal.category.emojiIconName != null)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(end: 8),
                                child: TextFont(
                                  text: categoryWithTotal.category.emojiIconName!,
                                  fontSize: 20,
                                ),
                              )
                            else
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color:
                                      HexColor(categoryWithTotal.category.colour),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextFont(
                                text: categoryWithTotal.category.name,
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            TextFont(
                              text: convertToMoney(
                                Provider.of<AllWallets>(context),
                                categoryWithTotal.total,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(width: 8),
                            TextFont(
                              text: convertToPercent(
                                  categoryWithTotal.total / total * 100),
                              fontSize: 14,
                              textColor: getColor(context, "textLight"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Past Performance Graph Widget (History Tab)
class InvestmentsPastPerformanceGraph extends StatefulWidget {
  const InvestmentsPastPerformanceGraph({
    required this.onEntryTapped,
    required this.selectedDateTimeRange,
    super.key,
  });
  final Function(DateTimeRange tappedRange, int tappedRangeIndex) onEntryTapped;
  final DateTimeRange? selectedDateTimeRange;

  @override
  State<InvestmentsPastPerformanceGraph> createState() =>
      _InvestmentsPastPerformanceGraphState();
}

class _InvestmentsPastPerformanceGraphState
    extends State<InvestmentsPastPerformanceGraph> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: getHorizontalPaddingConstrained(context) + 13,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextFont(
              text: "portfolio-performance".tr(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10),
            StreamBuilder<List<Investment>>(
              stream: database.watchAllInvestments(hideArchived: true),
              builder: (context, investmentsSnapshot) {
                if (!investmentsSnapshot.hasData ||
                    investmentsSnapshot.data!.isEmpty) {
                  return Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: getColor(context, "lightDarkAccentHeavyLight"),
                      borderRadius: BorderRadius.circular(
                        getPlatform() == PlatformOS.isIOS ? 0 : 15,
                      ),
                    ),
                    child: Center(
                      child: TextFont(
                        text: "no-investment-data".tr(),
                        textColor: getColor(context, "textLight"),
                      ),
                    ),
                  );
                }

                final investments = investmentsSnapshot.data!;
                final totalCurrent = investments.fold<double>(
                  0,
                  (sum, inv) => sum + (inv.shares * inv.currentPrice),
                );
                final totalInitial = investments.fold<double>(
                  0,
                  (sum, inv) => sum + (inv.shares * inv.purchasePrice),
                );

                // Build a simple 2-point graph showing initial vs current
                return Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: getColor(context, "lightDarkAccentHeavyLight"),
                    borderRadius: BorderRadius.circular(
                      getPlatform() == PlatformOS.isIOS ? 0 : 15,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(15),
                    child: LineChartWrapper(
                      points: [
                        [
                          Pair(0, totalInitial),
                          Pair(1, totalCurrent),
                        ]
                      ],
                      isCurved: true,
                      amountBefore: 0,
                      endDate: DateTime.now(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Helper Widget - SelectedPeriodHeaderLabel
class SelectedPeriodHeaderLabel extends StatelessWidget {
  const SelectedPeriodHeaderLabel({
    required this.color,
    required this.textColor,
    required this.text,
    required this.onTap,
    required this.iconData,
    super.key,
  });
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      color: color,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.all(5),
              child: Icon(
                iconData,
                size: 24,
                color: textColor,
              ),
            ),
            SizedBox(
              width: 3,
            ),
            Flexible(
              child: TextFont(
                text: text,
                fontSize: 18.5,
                textColor: textColor,
                fontWeight: FontWeight.bold,
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
      borderRadius: getPlatform() == PlatformOS.isIOS ? 10 : 15,
      onTap: onTap,
    );
  }
}
