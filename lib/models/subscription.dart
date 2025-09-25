// models/subscription.dart

enum SubscriptionPlan {
  free,
  premium,
  family,
  business,
}

enum SubscriptionStatus {
  active,
  cancelled,
  expired,
  paused,
  trial,
}

enum BillingCycle {
  monthly,
  yearly,
  lifetime,
}

class SubscriptionPlanDetails {
  final SubscriptionPlan plan;
  final String name;
  final String description;
  final double price;
  final BillingCycle billingCycle;
  final List<String> features;
  final int maxAccounts;
  final int maxGoals;
  final int maxBudgets;
  final bool hasAdvancedAnalytics;
  final bool hasPrioritySupport;
  final bool hasCustomCategories;
  final bool hasDataExport;
  final bool hasCollaboration;

  const SubscriptionPlanDetails({
    required this.plan,
    required this.name,
    required this.description,
    required this.price,
    required this.billingCycle,
    required this.features,
    this.maxAccounts = 1,
    this.maxGoals = 5,
    this.maxBudgets = 3,
    this.hasAdvancedAnalytics = false,
    this.hasPrioritySupport = false,
    this.hasCustomCategories = false,
    this.hasDataExport = false,
    this.hasCollaboration = false,
  });

  static const List<SubscriptionPlanDetails> allPlans = [
    SubscriptionPlanDetails(
      plan: SubscriptionPlan.free,
      name: 'Free',
      description: 'Perfect for getting started with basic financial tracking',
      price: 0.0,
      billingCycle: BillingCycle.monthly,
      features: [
        'Basic transaction tracking',
        'Simple budgeting',
        'Goal setting (up to 3)',
        'Bill reminders',
        'Basic reports',
      ],
      maxAccounts: 1,
      maxGoals: 3,
      maxBudgets: 2,
      hasAdvancedAnalytics: false,
      hasPrioritySupport: false,
      hasCustomCategories: false,
      hasDataExport: false,
      hasCollaboration: false,
    ),
    SubscriptionPlanDetails(
      plan: SubscriptionPlan.premium,
      name: 'Premium',
      description: 'Advanced features for serious financial management',
      price: 9.99,
      billingCycle: BillingCycle.monthly,
      features: [
        'Unlimited transactions',
        'Advanced budgeting',
        'Unlimited goals',
        'Credit score monitoring',
        'Cash flow forecasting',
        'Financial education',
        'Advanced analytics',
        'Data export',
        'Custom categories',
        'Priority support',
      ],
      maxAccounts: 1,
      maxGoals: -1, // unlimited
      maxBudgets: -1, // unlimited
      hasAdvancedAnalytics: true,
      hasPrioritySupport: true,
      hasCustomCategories: true,
      hasDataExport: true,
      hasCollaboration: false,
    ),
    SubscriptionPlanDetails(
      plan: SubscriptionPlan.family,
      name: 'Family',
      description: 'Share financial management with your family',
      price: 19.99,
      billingCycle: BillingCycle.monthly,
      features: [
        'All Premium features',
        'Up to 5 family members',
        'Shared budgets and goals',
        'Family expense tracking',
        'Collaborative planning',
        'Family financial insights',
      ],
      maxAccounts: 5,
      maxGoals: -1, // unlimited
      maxBudgets: -1, // unlimited
      hasAdvancedAnalytics: true,
      hasPrioritySupport: true,
      hasCustomCategories: true,
      hasDataExport: true,
      hasCollaboration: true,
    ),
    SubscriptionPlanDetails(
      plan: SubscriptionPlan.business,
      name: 'Business',
      description: 'Comprehensive financial management for businesses',
      price: 49.99,
      billingCycle: BillingCycle.monthly,
      features: [
        'All Family features',
        'Unlimited team members',
        'Business expense tracking',
        'Tax category management',
        'Advanced reporting',
        'Multi-currency support',
        'API access',
        'Dedicated support',
      ],
      maxAccounts: -1, // unlimited
      maxGoals: -1, // unlimited
      maxBudgets: -1, // unlimited
      hasAdvancedAnalytics: true,
      hasPrioritySupport: true,
      hasCustomCategories: true,
      hasDataExport: true,
      hasCollaboration: true,
    ),
  ];

  static SubscriptionPlanDetails getPlanDetails(SubscriptionPlan plan) {
    return allPlans.firstWhere((p) => p.plan == plan);
  }
}

class UserSubscription {
  final String id;
  final String userId;
  final SubscriptionPlan plan;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? trialEndDate;
  final BillingCycle billingCycle;
  final double price;
  final String? paymentMethodId;
  final bool autoRenew;
  final DateTime createdDate;
  final DateTime lastUpdated;
  final String? cancellationReason;
  final List<String> activeFeatures;

  UserSubscription({
    required this.id,
    required this.userId,
    required this.plan,
    required this.status,
    required this.startDate,
    this.endDate,
    this.trialEndDate,
    required this.billingCycle,
    required this.price,
    this.paymentMethodId,
    this.autoRenew = true,
    required this.createdDate,
    required this.lastUpdated,
    this.cancellationReason,
    this.activeFeatures = const [],
  });

  // Helper methods
  bool get isActive => status == SubscriptionStatus.active;
  bool get isTrial => status == SubscriptionStatus.trial;
  bool get isExpired => status == SubscriptionStatus.expired;
  bool get isCancelled => status == SubscriptionStatus.cancelled;
  bool get isPaused => status == SubscriptionStatus.paused;

  bool get hasTrial => trialEndDate != null;
  bool get isInTrial => hasTrial && DateTime.now().isBefore(trialEndDate!);
  int get trialDaysRemaining => isInTrial
      ? trialEndDate!.difference(DateTime.now()).inDays
      : 0;

  SubscriptionPlanDetails get planDetails => SubscriptionPlanDetails.getPlanDetails(plan);

  bool hasFeature(String feature) => activeFeatures.contains(feature);

  UserSubscription copyWith({
    String? id,
    String? userId,
    SubscriptionPlan? plan,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? trialEndDate,
    BillingCycle? billingCycle,
    double? price,
    String? paymentMethodId,
    bool? autoRenew,
    DateTime? createdDate,
    DateTime? lastUpdated,
    String? cancellationReason,
    List<String>? activeFeatures,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      billingCycle: billingCycle ?? this.billingCycle,
      price: price ?? this.price,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      autoRenew: autoRenew ?? this.autoRenew,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      activeFeatures: activeFeatures ?? this.activeFeatures,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'plan': plan.index,
      'status': status.index,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'trialEndDate': trialEndDate?.toIso8601String(),
      'billingCycle': billingCycle.index,
      'price': price,
      'paymentMethodId': paymentMethodId,
      'autoRenew': autoRenew,
      'createdDate': createdDate.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'cancellationReason': cancellationReason,
      'activeFeatures': activeFeatures,
    };
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'],
      userId: json['userId'],
      plan: SubscriptionPlan.values[json['plan']],
      status: SubscriptionStatus.values[json['status']],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      trialEndDate: json['trialEndDate'] != null ? DateTime.parse(json['trialEndDate']) : null,
      billingCycle: BillingCycle.values[json['billingCycle']],
      price: json['price'],
      paymentMethodId: json['paymentMethodId'],
      autoRenew: json['autoRenew'] ?? true,
      createdDate: DateTime.parse(json['createdDate']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      cancellationReason: json['cancellationReason'],
      activeFeatures: List<String>.from(json['activeFeatures'] ?? []),
    );
  }
}

class PaymentMethod {
  final String id;
  final String userId;
  final String type; // 'card', 'paypal', 'bank'
  final String last4;
  final String brand;
  final bool isDefault;
  final DateTime createdDate;
  final Map<String, dynamic>? metadata;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.last4,
    required this.brand,
    this.isDefault = false,
    required this.createdDate,
    this.metadata,
  });

  PaymentMethod copyWith({
    String? id,
    String? userId,
    String? type,
    String? last4,
    String? brand,
    bool? isDefault,
    DateTime? createdDate,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      last4: last4 ?? this.last4,
      brand: brand ?? this.brand,
      isDefault: isDefault ?? this.isDefault,
      createdDate: createdDate ?? this.createdDate,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'last4': last4,
      'brand': brand,
      'isDefault': isDefault,
      'createdDate': createdDate.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      last4: json['last4'],
      brand: json['brand'],
      isDefault: json['isDefault'] ?? false,
      createdDate: DateTime.parse(json['createdDate']),
      metadata: json['metadata'],
    );
  }
}