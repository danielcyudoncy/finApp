// models/budget.dart
import 'package:flutter/material.dart';

enum BudgetPeriod {
  weekly,
  monthly,
  yearly,
}

class Budget {
  final String id;
  final String name;
  final String category;
  final double amount;
  final BudgetPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final double spent;
  final bool isActive;
  final String? parentBudgetId; // For sub-budgets
  final List<int> alertThresholds; // e.g., [80, 90, 100] for percentage alerts

  Budget({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.spent = 0.0,
    this.isActive = true,
    this.parentBudgetId,
    this.alertThresholds = const [80, 90, 100],
  });

  // Helper methods
  double get remaining => amount - spent;
  double get progress => spent / amount;
  bool get isOverBudget => spent > amount;
  bool get isNearLimit => progress >= 0.8;

  String get periodName {
    switch (period) {
      case BudgetPeriod.weekly:
        return 'Weekly';
      case BudgetPeriod.monthly:
        return 'Monthly';
      case BudgetPeriod.yearly:
        return 'Yearly';
    }
  }

  Color get statusColor {
    if (isOverBudget) return Colors.red;
    if (isNearLimit) return Colors.orange;
    return Colors.green;
  }

  String get statusText {
    if (isOverBudget) return 'Over Budget';
    if (isNearLimit) return 'Near Limit';
    return 'On Track';
  }

  // Check if budget needs alerts
  List<int> get triggeredAlerts {
    return alertThresholds
        .where((threshold) => progress >= (threshold / 100))
        .toList();
  }

  // Create a copy with modified fields
  Budget copyWith({
    String? id,
    String? name,
    String? category,
    double? amount,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    double? spent,
    bool? isActive,
    String? parentBudgetId,
    List<int>? alertThresholds,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      spent: spent ?? this.spent,
      isActive: isActive ?? this.isActive,
      parentBudgetId: parentBudgetId ?? this.parentBudgetId,
      alertThresholds: alertThresholds ?? this.alertThresholds,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'amount': amount,
      'period': period.index,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'spent': spent,
      'isActive': isActive,
      'parentBudgetId': parentBudgetId,
      'alertThresholds': alertThresholds,
    };
  }

  // Create from JSON
  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      amount: json['amount'],
      period: BudgetPeriod.values[json['period']],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      spent: json['spent'] ?? 0.0,
      isActive: json['isActive'] ?? true,
      parentBudgetId: json['parentBudgetId'],
      alertThresholds: json['alertThresholds']?.map<int>((e) => e as int)?.toList() ?? [80, 90, 100],
    );
  }
}