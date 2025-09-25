// models/transaction.dart
import 'package:flutter/material.dart';

enum TransactionType {
  income,
  expense,
}

enum TransactionCategory {
  groceries,
  entertainment,
  diningOut,
  transportation,
  shopping,
  utilities,
  healthcare,
  education,
  salary,
  freelance,
  investment,
  other,
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String? description;
  final String? accountId;
  final bool isRecurring;
  final String? recurringId;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
    this.accountId,
    this.isRecurring = false,
    this.recurringId,
  });

  // Helper methods
  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  String get categoryName {
    switch (category) {
      case TransactionCategory.groceries:
        return 'Groceries';
      case TransactionCategory.entertainment:
        return 'Entertainment';
      case TransactionCategory.diningOut:
        return 'Dining Out';
      case TransactionCategory.transportation:
        return 'Transportation';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.utilities:
        return 'Utilities';
      case TransactionCategory.healthcare:
        return 'Healthcare';
      case TransactionCategory.education:
        return 'Education';
      case TransactionCategory.salary:
        return 'Salary';
      case TransactionCategory.freelance:
        return 'Freelance';
      case TransactionCategory.investment:
        return 'Investment';
      case TransactionCategory.other:
        return 'Other';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case TransactionCategory.groceries:
        return Icons.shopping_cart;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.diningOut:
        return Icons.restaurant;
      case TransactionCategory.transportation:
        return Icons.directions_car;
      case TransactionCategory.shopping:
        return Icons.shopping_bag;
      case TransactionCategory.utilities:
        return Icons.electric_bolt;
      case TransactionCategory.healthcare:
        return Icons.local_hospital;
      case TransactionCategory.education:
        return Icons.school;
      case TransactionCategory.salary:
        return Icons.work;
      case TransactionCategory.freelance:
        return Icons.laptop;
      case TransactionCategory.investment:
        return Icons.trending_up;
      case TransactionCategory.other:
        return Icons.category;
    }
  }

  Color get categoryColor {
    switch (category) {
      case TransactionCategory.groceries:
        return Colors.orange;
      case TransactionCategory.entertainment:
        return Colors.purple;
      case TransactionCategory.diningOut:
        return Colors.red;
      case TransactionCategory.transportation:
        return Colors.blue;
      case TransactionCategory.shopping:
        return Colors.pink;
      case TransactionCategory.utilities:
        return Colors.yellow;
      case TransactionCategory.healthcare:
        return Colors.green;
      case TransactionCategory.education:
        return Colors.indigo;
      case TransactionCategory.salary:
        return Colors.green;
      case TransactionCategory.freelance:
        return Colors.teal;
      case TransactionCategory.investment:
        return Colors.amber;
      case TransactionCategory.other:
        return Colors.grey;
    }
  }

  // Create a copy with modified fields
  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
    String? description,
    String? accountId,
    bool? isRecurring,
    String? recurringId,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      accountId: accountId ?? this.accountId,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringId: recurringId ?? this.recurringId,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.index,
      'category': category.index,
      'date': date.toIso8601String(),
      'description': description,
      'accountId': accountId,
      'isRecurring': isRecurring,
      'recurringId': recurringId,
    };
  }

  // Create from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      type: TransactionType.values[json['type']],
      category: TransactionCategory.values[json['category']],
      date: DateTime.parse(json['date']),
      description: json['description'],
      accountId: json['accountId'],
      isRecurring: json['isRecurring'] ?? false,
      recurringId: json['recurringId'],
    );
  }
}