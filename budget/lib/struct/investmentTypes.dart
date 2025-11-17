import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class InvestmentType {
  final String key;
  final String Function() nameFunction;
  final Color color;
  final IconData icon;

  InvestmentType({
    required this.key,
    required this.nameFunction,
    required this.color,
    required this.icon,
  });

  String get name => nameFunction();
}

List<InvestmentType> getInvestmentTypes() {
  return [
    InvestmentType(
      key: 'stock',
      nameFunction: () => 'investment-type-stock'.tr(),
      color: Colors.blue.shade600,
      icon: Icons.trending_up_rounded,
    ),
    InvestmentType(
      key: 'etf',
      nameFunction: () => 'investment-type-etf'.tr(),
      color: Colors.cyan.shade700,
      icon: Icons.assessment_rounded,
    ),
    InvestmentType(
      key: 'crypto',
      nameFunction: () => 'investment-type-crypto'.tr(),
      color: Colors.orange.shade600,
      icon: Icons.currency_bitcoin_rounded,
    ),
    InvestmentType(
      key: 'bond',
      nameFunction: () => 'investment-type-bond'.tr(),
      color: Colors.green.shade700,
      icon: Icons.attach_money_rounded,
    ),
    InvestmentType(
      key: 'real-estate',
      nameFunction: () => 'investment-type-real-estate'.tr(),
      color: Colors.brown.shade600,
      icon: Icons.home_rounded,
    ),
    InvestmentType(
      key: 'commodity',
      nameFunction: () => 'investment-type-commodity'.tr(),
      color: Colors.yellow.shade800,
      icon: Icons.diamond_rounded,
    ),
    InvestmentType(
      key: 'mutual-fund',
      nameFunction: () => 'investment-type-mutual-fund'.tr(),
      color: Colors.indigo.shade600,
      icon: Icons.pie_chart_rounded,
    ),
    InvestmentType(
      key: 'other',
      nameFunction: () => 'investment-type-other'.tr(),
      color: Colors.grey.shade600,
      icon: Icons.more_horiz_rounded,
    ),
    InvestmentType(
      key: 'bank-account',
      nameFunction: () => 'bank-accounts'.tr(),
      color: Colors.teal.shade700,
      icon: Icons.account_balance_rounded,
    ),
  ];
}

InvestmentType? getInvestmentTypeByKey(String? key) {
  if (key == null) return null;
  try {
    return getInvestmentTypes().firstWhere((type) => type.key == key);
  } catch (e) {
    return null;
  }
}

Color getInvestmentTypeColor(String? key) {
  final type = getInvestmentTypeByKey(key);
  return type?.color ?? Colors.grey.shade600;
}

IconData getInvestmentTypeIcon(String? key) {
  final type = getInvestmentTypeByKey(key);
  return type?.icon ?? Icons.show_chart_rounded;
}

String getInvestmentTypeName(String? key) {
  final type = getInvestmentTypeByKey(key);
  return type?.name ?? 'uncategorized'.tr();
}
