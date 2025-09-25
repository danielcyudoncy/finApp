// models/credit_score.dart
import 'package:flutter/material.dart';

enum CreditScoreRange {
  poor,      // 300-579
  fair,      // 580-669
  good,      // 670-739
  veryGood,  // 740-799
  excellent, // 800-850
}

class CreditScore {
  final String id;
  final int score;
  final DateTime lastUpdated;
  final DateTime createdDate;
  final Map<String, dynamic> factors; // Payment history, credit utilization, etc.
  final List<CreditScoreHistory> history;
  final List<String> recommendations;

  CreditScore({
    required this.id,
    required this.score,
    required this.lastUpdated,
    required this.createdDate,
    this.factors = const {},
    this.history = const [],
    this.recommendations = const [],
  });

  // Helper methods
  CreditScoreRange get range {
    if (score >= 800) return CreditScoreRange.excellent;
    if (score >= 740) return CreditScoreRange.veryGood;
    if (score >= 670) return CreditScoreRange.good;
    if (score >= 580) return CreditScoreRange.fair;
    return CreditScoreRange.poor;
  }

  String get rangeText {
    switch (range) {
      case CreditScoreRange.poor:
        return 'Poor';
      case CreditScoreRange.fair:
        return 'Fair';
      case CreditScoreRange.good:
        return 'Good';
      case CreditScoreRange.veryGood:
        return 'Very Good';
      case CreditScoreRange.excellent:
        return 'Excellent';
    }
  }

  Color get rangeColor {
    switch (range) {
      case CreditScoreRange.poor:
        return Colors.red;
      case CreditScoreRange.fair:
        return Colors.orange;
      case CreditScoreRange.good:
        return Colors.yellow.shade700;
      case CreditScoreRange.veryGood:
        return Colors.lightGreen;
      case CreditScoreRange.excellent:
        return Colors.green;
    }
  }

  bool get isGood => score >= 670;
  bool get isExcellent => score >= 740;

  // Create a copy with modified fields
  CreditScore copyWith({
    String? id,
    int? score,
    DateTime? lastUpdated,
    DateTime? createdDate,
    Map<String, dynamic>? factors,
    List<CreditScoreHistory>? history,
    List<String>? recommendations,
  }) {
    return CreditScore(
      id: id ?? this.id,
      score: score ?? this.score,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdDate: createdDate ?? this.createdDate,
      factors: factors ?? this.factors,
      history: history ?? this.history,
      recommendations: recommendations ?? this.recommendations,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
      'lastUpdated': lastUpdated.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'factors': factors,
      'history': history.map((h) => h.toJson()).toList(),
      'recommendations': recommendations,
    };
  }

  // Create from JSON
  factory CreditScore.fromJson(Map<String, dynamic> json) {
    return CreditScore(
      id: json['id'],
      score: json['score'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      createdDate: DateTime.parse(json['createdDate']),
      factors: json['factors'] ?? {},
      history: (json['history'] as List<dynamic>?)
              ?.map((h) => CreditScoreHistory.fromJson(h))
              .toList() ??
          [],
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}

class CreditScoreHistory {
  final DateTime date;
  final int score;
  final String event; // e.g., "Payment made", "Credit inquiry"

  CreditScoreHistory({
    required this.date,
    required this.score,
    required this.event,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'score': score,
      'event': event,
    };
  }

  factory CreditScoreHistory.fromJson(Map<String, dynamic> json) {
    return CreditScoreHistory(
      date: DateTime.parse(json['date']),
      score: json['score'],
      event: json['event'],
    );
  }
}