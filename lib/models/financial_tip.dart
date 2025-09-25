// models/financial_tip.dart
import 'package:flutter/material.dart';

enum TipCategory {
  budgeting,
  saving,
  investing,
  debtManagement,
  creditScore,
  taxes,
  insurance,
  retirement,
  general,
}

enum TipDifficulty {
  beginner,
  intermediate,
  advanced,
}

class FinancialTip {
  final String id;
  final String title;
  final String content;
  final TipCategory category;
  final TipDifficulty difficulty;
  final DateTime createdDate;
  final String? imageUrl;
  final List<String> tags;
  final int readTimeMinutes;
  final bool isPremium;
  final String? source;

  FinancialTip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.difficulty,
    required this.createdDate,
    this.imageUrl,
    this.tags = const [],
    this.readTimeMinutes = 5,
    this.isPremium = false,
    this.source,
  });

  // Helper methods
  String get categoryName {
    switch (category) {
      case TipCategory.budgeting:
        return 'Budgeting';
      case TipCategory.saving:
        return 'Saving';
      case TipCategory.investing:
        return 'Investing';
      case TipCategory.debtManagement:
        return 'Debt Management';
      case TipCategory.creditScore:
        return 'Credit Score';
      case TipCategory.taxes:
        return 'Taxes';
      case TipCategory.insurance:
        return 'Insurance';
      case TipCategory.retirement:
        return 'Retirement';
      case TipCategory.general:
        return 'General';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case TipCategory.budgeting:
        return Icons.pie_chart;
      case TipCategory.saving:
        return Icons.savings;
      case TipCategory.investing:
        return Icons.trending_up;
      case TipCategory.debtManagement:
        return Icons.credit_card;
      case TipCategory.creditScore:
        return Icons.score;
      case TipCategory.taxes:
        return Icons.receipt_long;
      case TipCategory.insurance:
        return Icons.security;
      case TipCategory.retirement:
        return Icons.chair;
      case TipCategory.general:
        return Icons.lightbulb;
    }
  }

  Color get categoryColor {
    switch (category) {
      case TipCategory.budgeting:
        return Colors.blue;
      case TipCategory.saving:
        return Colors.green;
      case TipCategory.investing:
        return Colors.purple;
      case TipCategory.debtManagement:
        return Colors.red;
      case TipCategory.creditScore:
        return Colors.orange;
      case TipCategory.taxes:
        return Colors.indigo;
      case TipCategory.insurance:
        return Colors.teal;
      case TipCategory.retirement:
        return Colors.brown;
      case TipCategory.general:
        return Colors.amber;
    }
  }

  String get difficultyText {
    switch (difficulty) {
      case TipDifficulty.beginner:
        return 'Beginner';
      case TipDifficulty.intermediate:
        return 'Intermediate';
      case TipDifficulty.advanced:
        return 'Advanced';
    }
  }

  Color get difficultyColor {
    switch (difficulty) {
      case TipDifficulty.beginner:
        return Colors.green;
      case TipDifficulty.intermediate:
        return Colors.orange;
      case TipDifficulty.advanced:
        return Colors.red;
    }
  }

  // Create a copy with modified fields
  FinancialTip copyWith({
    String? id,
    String? title,
    String? content,
    TipCategory? category,
    TipDifficulty? difficulty,
    DateTime? createdDate,
    String? imageUrl,
    List<String>? tags,
    int? readTimeMinutes,
    bool? isPremium,
    String? source,
  }) {
    return FinancialTip(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      createdDate: createdDate ?? this.createdDate,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      isPremium: isPremium ?? this.isPremium,
      source: source ?? this.source,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category.index,
      'difficulty': difficulty.index,
      'createdDate': createdDate.toIso8601String(),
      'imageUrl': imageUrl,
      'tags': tags,
      'readTimeMinutes': readTimeMinutes,
      'isPremium': isPremium,
      'source': source,
    };
  }

  // Create from JSON
  factory FinancialTip.fromJson(Map<String, dynamic> json) {
    return FinancialTip(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: TipCategory.values[json['category']],
      difficulty: TipDifficulty.values[json['difficulty']],
      createdDate: DateTime.parse(json['createdDate']),
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      readTimeMinutes: json['readTimeMinutes'] ?? 5,
      isPremium: json['isPremium'] ?? false,
      source: json['source'],
    );
  }
}

class UserTipProgress {
  final String tipId;
  final bool isRead;
  final bool isBookmarked;
  final DateTime? readDate;
  final int? rating; // 1-5 stars

  UserTipProgress({
    required this.tipId,
    this.isRead = false,
    this.isBookmarked = false,
    this.readDate,
    this.rating,
  });

  UserTipProgress copyWith({
    String? tipId,
    bool? isRead,
    bool? isBookmarked,
    DateTime? readDate,
    int? rating,
  }) {
    return UserTipProgress(
      tipId: tipId ?? this.tipId,
      isRead: isRead ?? this.isRead,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      readDate: readDate ?? this.readDate,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipId': tipId,
      'isRead': isRead,
      'isBookmarked': isBookmarked,
      'readDate': readDate?.toIso8601String(),
      'rating': rating,
    };
  }

  factory UserTipProgress.fromJson(Map<String, dynamic> json) {
    return UserTipProgress(
      tipId: json['tipId'],
      isRead: json['isRead'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
      readDate: json['readDate'] != null ? DateTime.parse(json['readDate']) : null,
      rating: json['rating'],
    );
  }
}