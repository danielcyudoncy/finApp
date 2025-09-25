// models/goal.dart
import 'package:flutter/material.dart';

enum GoalType {
  savings,
  debtPayoff,
  investment,
  purchase,
  emergencyFund,
  vacation,
  education,
  other,
}

enum GoalStatus {
  active,
  completed,
  paused,
  cancelled,
}

class Goal {
  final String id;
  final String name;
  final String description;
  final GoalType type;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final DateTime createdDate;
  final GoalStatus status;
  final String? category;
  final bool isAutomated; // For automatic contributions
  final double? monthlyContribution;
  final List<String> tags;
  final String? imageUrl;

  Goal({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.createdDate,
    this.status = GoalStatus.active,
    this.category,
    this.isAutomated = false,
    this.monthlyContribution,
    this.tags = const [],
    this.imageUrl,
  });

  // Helper methods
  double get progress => currentAmount / targetAmount;
  double get remaining => targetAmount - currentAmount;
  bool get isCompleted => status == GoalStatus.completed;
  bool get isOnTrack => progress >= 0.5;
  bool get isBehind => progress < 0.3;

  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;
  bool get isOverdue => daysRemaining < 0 && !isCompleted;

  String get typeName {
    switch (type) {
      case GoalType.savings:
        return 'Savings';
      case GoalType.debtPayoff:
        return 'Debt Payoff';
      case GoalType.investment:
        return 'Investment';
      case GoalType.purchase:
        return 'Purchase';
      case GoalType.emergencyFund:
        return 'Emergency Fund';
      case GoalType.vacation:
        return 'Vacation';
      case GoalType.education:
        return 'Education';
      case GoalType.other:
        return 'Other';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case GoalType.savings:
        return Icons.savings;
      case GoalType.debtPayoff:
        return Icons.credit_card;
      case GoalType.investment:
        return Icons.trending_up;
      case GoalType.purchase:
        return Icons.shopping_cart;
      case GoalType.emergencyFund:
        return Icons.security;
      case GoalType.vacation:
        return Icons.beach_access;
      case GoalType.education:
        return Icons.school;
      case GoalType.other:
        return Icons.flag;
    }
  }

  Color get statusColor {
    switch (status) {
      case GoalStatus.active:
        return isOverdue ? Colors.red : Colors.green;
      case GoalStatus.completed:
        return Colors.green;
      case GoalStatus.paused:
        return Colors.orange;
      case GoalStatus.cancelled:
        return Colors.grey;
    }
  }

  String get statusText {
    switch (status) {
      case GoalStatus.active:
        return isOverdue ? 'Overdue' : 'Active';
      case GoalStatus.completed:
        return 'Completed';
      case GoalStatus.paused:
        return 'Paused';
      case GoalStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Calculate suggested monthly contribution
  double get suggestedMonthlyContribution {
    if (daysRemaining <= 0) return 0;
    return remaining / daysRemaining * 30;
  }

  // Create a copy with modified fields
  Goal copyWith({
    String? id,
    String? name,
    String? description,
    GoalType? type,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    DateTime? createdDate,
    GoalStatus? status,
    String? category,
    bool? isAutomated,
    double? monthlyContribution,
    List<String>? tags,
    String? imageUrl,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      createdDate: createdDate ?? this.createdDate,
      status: status ?? this.status,
      category: category ?? this.category,
      isAutomated: isAutomated ?? this.isAutomated,
      monthlyContribution: monthlyContribution ?? this.monthlyContribution,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'status': status.index,
      'category': category,
      'isAutomated': isAutomated,
      'monthlyContribution': monthlyContribution,
      'tags': tags,
      'imageUrl': imageUrl,
    };
  }

  // Create from JSON
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: GoalType.values[json['type']],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'],
      targetDate: DateTime.parse(json['targetDate']),
      createdDate: DateTime.parse(json['createdDate']),
      status: GoalStatus.values[json['status']],
      category: json['category'],
      isAutomated: json['isAutomated'] ?? false,
      monthlyContribution: json['monthlyContribution'],
      tags: List<String>.from(json['tags'] ?? []),
      imageUrl: json['imageUrl'],
    );
  }
}