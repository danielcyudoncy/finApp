// models/account.dart
import 'package:flutter/material.dart';

enum AccountType {
  checking,
  savings,
  creditCard,
  investment,
  loan,
  cash,
}

enum AccountStatus {
  active,
  inactive,
  frozen,
  closed,
}

class Account {
  final String id;
  final String name;
  final String institution;
  final AccountType type;
  final String accountNumber; // Masked for display
  final double balance;
  final double availableBalance;
  final String currency;
  final AccountStatus status;
  final DateTime createdDate;
  final DateTime lastUpdated;
  final bool isDefault;
  final String? color; // Hex color for UI
  final Map<String, dynamic>? metadata;

  Account({
    required this.id,
    required this.name,
    required this.institution,
    required this.type,
    required this.accountNumber,
    required this.balance,
    required this.availableBalance,
    this.currency = 'USD',
    this.status = AccountStatus.active,
    required this.createdDate,
    required this.lastUpdated,
    this.isDefault = false,
    this.color,
    this.metadata,
  });

  // Helper methods
  bool get isActive => status == AccountStatus.active;
  bool get isCreditCard => type == AccountType.creditCard;
  bool get isDebitAccount => type == AccountType.checking || type == AccountType.savings;
  double get creditLimit => isCreditCard ? (metadata?['creditLimit'] ?? 0.0) : 0.0;
  double get creditUsed => isCreditCard ? (balance.abs()) : 0.0;
  double get creditAvailable => creditLimit - creditUsed;

  String get typeName {
    switch (type) {
      case AccountType.checking:
        return 'Checking';
      case AccountType.savings:
        return 'Savings';
      case AccountType.creditCard:
        return 'Credit Card';
      case AccountType.investment:
        return 'Investment';
      case AccountType.loan:
        return 'Loan';
      case AccountType.cash:
        return 'Cash';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case AccountType.checking:
        return Icons.account_balance;
      case AccountType.savings:
        return Icons.savings;
      case AccountType.creditCard:
        return Icons.credit_card;
      case AccountType.investment:
        return Icons.trending_up;
      case AccountType.loan:
        return Icons.money_off;
      case AccountType.cash:
        return Icons.money;
    }
  }

  Color get statusColor {
    switch (status) {
      case AccountStatus.active:
        return Colors.green;
      case AccountStatus.inactive:
        return Colors.orange;
      case AccountStatus.frozen:
        return Colors.blue;
      case AccountStatus.closed:
        return Colors.grey;
    }
  }

  String get statusText {
    switch (status) {
      case AccountStatus.active:
        return 'Active';
      case AccountStatus.inactive:
        return 'Inactive';
      case AccountStatus.frozen:
        return 'Frozen';
      case AccountStatus.closed:
        return 'Closed';
    }
  }

  // Format account number for display (show last 4 digits)
  String get displayAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return '****${accountNumber.substring(accountNumber.length - 4)}';
  }

  // Create a copy with modified fields
  Account copyWith({
    String? id,
    String? name,
    String? institution,
    AccountType? type,
    String? accountNumber,
    double? balance,
    double? availableBalance,
    String? currency,
    AccountStatus? status,
    DateTime? createdDate,
    DateTime? lastUpdated,
    bool? isDefault,
    String? color,
    Map<String, dynamic>? metadata,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      institution: institution ?? this.institution,
      type: type ?? this.type,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      availableBalance: availableBalance ?? this.availableBalance,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isDefault: isDefault ?? this.isDefault,
      color: color ?? this.color,
      metadata: metadata ?? this.metadata,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'institution': institution,
      'type': type.index,
      'accountNumber': accountNumber,
      'balance': balance,
      'availableBalance': availableBalance,
      'currency': currency,
      'status': status.index,
      'createdDate': createdDate.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'isDefault': isDefault,
      'color': color,
      'metadata': metadata,
    };
  }

  // Create from JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      institution: json['institution'],
      type: AccountType.values[json['type']],
      accountNumber: json['accountNumber'],
      balance: json['balance'],
      availableBalance: json['availableBalance'],
      currency: json['currency'] ?? 'USD',
      status: AccountStatus.values[json['status']],
      createdDate: DateTime.parse(json['createdDate']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      isDefault: json['isDefault'] ?? false,
      color: json['color'],
      metadata: json['metadata'],
    );
  }
}