// models/bill.dart
import 'package:flutter/material.dart';

enum BillStatus {
  pending,
  paid,
  overdue,
  cancelled,
}

enum BillFrequency {
  oneTime,
  weekly,
  monthly,
  quarterly,
  yearly,
}

class Bill {
  final String id;
  final String name;
  final String description;
  final double amount;
  final DateTime dueDate;
  final DateTime createdDate;
  final BillStatus status;
  final BillFrequency frequency;
  final String? category;
  final String? accountId; // For auto-payment
  final bool autoPay;
  final bool sendReminders;
  final int reminderDays; // Days before due date to send reminder
  final String? attachmentUrl; // Receipt or bill image
  final Map<String, dynamic>? metadata; // Additional data

  Bill({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.createdDate,
    this.status = BillStatus.pending,
    this.frequency = BillFrequency.monthly,
    this.category,
    this.accountId,
    this.autoPay = false,
    this.sendReminders = true,
    this.reminderDays = 3,
    this.attachmentUrl,
    this.metadata,
  });

  // Helper methods
  bool get isPaid => status == BillStatus.paid;
  bool get isOverdue => status == BillStatus.overdue;
  bool get isPending => status == BillStatus.pending;

  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;
  bool get shouldSendReminder {
    if (!sendReminders) return false;
    return daysUntilDue <= reminderDays && daysUntilDue >= 0 && !isPaid;
  }

  String get frequencyName {
    switch (frequency) {
      case BillFrequency.oneTime:
        return 'One-time';
      case BillFrequency.weekly:
        return 'Weekly';
      case BillFrequency.monthly:
        return 'Monthly';
      case BillFrequency.quarterly:
        return 'Quarterly';
      case BillFrequency.yearly:
        return 'Yearly';
    }
  }

  IconData get statusIcon {
    switch (status) {
      case BillStatus.paid:
        return Icons.check_circle;
      case BillStatus.pending:
        return Icons.schedule;
      case BillStatus.overdue:
        return Icons.warning;
      case BillStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color get statusColor {
    switch (status) {
      case BillStatus.paid:
        return Colors.green;
      case BillStatus.pending:
        return Colors.blue;
      case BillStatus.overdue:
        return Colors.red;
      case BillStatus.cancelled:
        return Colors.grey;
    }
  }

  String get statusText {
    switch (status) {
      case BillStatus.paid:
        return 'Paid';
      case BillStatus.pending:
        return 'Pending';
      case BillStatus.overdue:
        return 'Overdue';
      case BillStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Calculate next due date for recurring bills
  DateTime? getNextDueDate() {
    if (frequency == BillFrequency.oneTime) return null;

    DateTime nextDate = dueDate;
    while (nextDate.isBefore(DateTime.now())) {
      switch (frequency) {
        case BillFrequency.weekly:
          nextDate = nextDate.add(const Duration(days: 7));
          break;
        case BillFrequency.monthly:
          nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
          break;
        case BillFrequency.quarterly:
          nextDate = DateTime(nextDate.year, nextDate.month + 3, nextDate.day);
          break;
        case BillFrequency.yearly:
          nextDate = DateTime(nextDate.year + 1, nextDate.month, nextDate.day);
          break;
        case BillFrequency.oneTime:
          return null;
      }
    }
    return nextDate;
  }

  // Create a copy with modified fields
  Bill copyWith({
    String? id,
    String? name,
    String? description,
    double? amount,
    DateTime? dueDate,
    DateTime? createdDate,
    BillStatus? status,
    BillFrequency? frequency,
    String? category,
    String? accountId,
    bool? autoPay,
    bool? sendReminders,
    int? reminderDays,
    String? attachmentUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Bill(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      createdDate: createdDate ?? this.createdDate,
      status: status ?? this.status,
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      accountId: accountId ?? this.accountId,
      autoPay: autoPay ?? this.autoPay,
      sendReminders: sendReminders ?? this.sendReminders,
      reminderDays: reminderDays ?? this.reminderDays,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'status': status.index,
      'frequency': frequency.index,
      'category': category,
      'accountId': accountId,
      'autoPay': autoPay,
      'sendReminders': sendReminders,
      'reminderDays': reminderDays,
      'attachmentUrl': attachmentUrl,
      'metadata': metadata,
    };
  }

  // Create from JSON
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: json['amount'],
      dueDate: DateTime.parse(json['dueDate']),
      createdDate: DateTime.parse(json['createdDate']),
      status: BillStatus.values[json['status']],
      frequency: BillFrequency.values[json['frequency']],
      category: json['category'],
      accountId: json['accountId'],
      autoPay: json['autoPay'] ?? false,
      sendReminders: json['sendReminders'] ?? true,
      reminderDays: json['reminderDays'] ?? 3,
      attachmentUrl: json['attachmentUrl'],
      metadata: json['metadata'],
    );
  }
}