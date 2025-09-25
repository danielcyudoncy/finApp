// models/cash_flow.dart
import 'package:flutter/material.dart';

enum CashFlowType {
  income,
  expense,
  transfer,
  investment,
  loan,
}

enum CashFlowFrequency {
  oneTime,
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
}

class CashFlow {
  final String id;
  final String title;
  final double amount;
  final CashFlowType type;
  final CashFlowFrequency frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final String? category;
  final String? accountId;
  final String? description;
  final bool isAutomated;
  final Map<String, dynamic>? metadata;

  CashFlow({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.category,
    this.accountId,
    this.description,
    this.isAutomated = false,
    this.metadata,
  });

  // Helper methods
  bool get isRecurring => frequency != CashFlowFrequency.oneTime;
  bool get isActive => endDate == null || endDate!.isAfter(DateTime.now());
  bool get isIncome => type == CashFlowType.income;
  bool get isExpense => type == CashFlowType.expense;

  String get frequencyText {
    switch (frequency) {
      case CashFlowFrequency.oneTime:
        return 'One-time';
      case CashFlowFrequency.daily:
        return 'Daily';
      case CashFlowFrequency.weekly:
        return 'Weekly';
      case CashFlowFrequency.monthly:
        return 'Monthly';
      case CashFlowFrequency.quarterly:
        return 'Quarterly';
      case CashFlowFrequency.yearly:
        return 'Yearly';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case CashFlowType.income:
        return Icons.arrow_upward;
      case CashFlowType.expense:
        return Icons.arrow_downward;
      case CashFlowType.transfer:
        return Icons.swap_horiz;
      case CashFlowType.investment:
        return Icons.trending_up;
      case CashFlowType.loan:
        return Icons.account_balance;
    }
  }

  Color get typeColor {
    switch (type) {
      case CashFlowType.income:
        return Colors.green;
      case CashFlowType.expense:
        return Colors.red;
      case CashFlowType.transfer:
        return Colors.blue;
      case CashFlowType.investment:
        return Colors.purple;
      case CashFlowType.loan:
        return Colors.orange;
    }
  }

  // Calculate next occurrence
  DateTime? getNextOccurrence() {
    if (!isActive) return null;

    DateTime nextDate = startDate;
    while (nextDate.isBefore(DateTime.now()) && isActive) {
      switch (frequency) {
        case CashFlowFrequency.daily:
          nextDate = nextDate.add(const Duration(days: 1));
          break;
        case CashFlowFrequency.weekly:
          nextDate = nextDate.add(const Duration(days: 7));
          break;
        case CashFlowFrequency.monthly:
          nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
          break;
        case CashFlowFrequency.quarterly:
          nextDate = DateTime(nextDate.year, nextDate.month + 3, nextDate.day);
          break;
        case CashFlowFrequency.yearly:
          nextDate = DateTime(nextDate.year + 1, nextDate.month, nextDate.day);
          break;
        case CashFlowFrequency.oneTime:
          return null;
      }
    }

    return nextDate.isBefore(DateTime.now()) ? null : nextDate;
  }

  // Create a copy with modified fields
  CashFlow copyWith({
    String? id,
    String? title,
    double? amount,
    CashFlowType? type,
    CashFlowFrequency? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? accountId,
    String? description,
    bool? isAutomated,
    Map<String, dynamic>? metadata,
  }) {
    return CashFlow(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
      accountId: accountId ?? this.accountId,
      description: description ?? this.description,
      isAutomated: isAutomated ?? this.isAutomated,
      metadata: metadata ?? this.metadata,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.index,
      'frequency': frequency.index,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'category': category,
      'accountId': accountId,
      'description': description,
      'isAutomated': isAutomated,
      'metadata': metadata,
    };
  }

  // Create from JSON
  factory CashFlow.fromJson(Map<String, dynamic> json) {
    return CashFlow(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      type: CashFlowType.values[json['type']],
      frequency: CashFlowFrequency.values[json['frequency']],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      category: json['category'],
      accountId: json['accountId'],
      description: json['description'],
      isAutomated: json['isAutomated'] ?? false,
      metadata: json['metadata'],
    );
  }
}

class CashFlowProjection {
  final DateTime date;
  final double projectedIncome;
  final double projectedExpenses;
  final double netFlow;
  final List<CashFlow> contributingFlows;

  CashFlowProjection({
    required this.date,
    required this.projectedIncome,
    required this.projectedExpenses,
    required this.netFlow,
    required this.contributingFlows,
  });

  double get balance => projectedIncome - projectedExpenses;
  bool get isPositive => netFlow >= 0;
  bool get isNegative => netFlow < 0;
}