// providers/finance_provider.dart
import 'package:flutter/material.dart';
import 'package:fin_app/models/transaction.dart';
import 'package:fin_app/models/budget.dart';
import 'package:fin_app/models/goal.dart';
import 'package:fin_app/models/bill.dart';
import 'package:fin_app/models/account.dart';
import 'package:fin_app/models/credit_score.dart';
import 'package:fin_app/models/cash_flow.dart';
import 'package:fin_app/models/financial_tip.dart';
import 'package:fin_app/models/security.dart';
import 'package:fin_app/models/subscription.dart';
import 'package:fin_app/models/collaboration.dart';

class FinanceProvider extends ChangeNotifier {
  // Sample data for demonstration
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Grocery Shopping',
      amount: 45.20,
      type: TransactionType.expense,
      category: TransactionCategory.groceries,
      date: DateTime.now().subtract(const Duration(hours: 6)),
      description: 'Weekly grocery shopping at Whole Foods',
    ),
    Transaction(
      id: '2',
      title: 'Salary Deposit',
      amount: 2500.00,
      type: TransactionType.income,
      category: TransactionCategory.salary,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Monthly salary from Tech Corp',
    ),
    Transaction(
      id: '3',
      title: 'Gas Station',
      amount: 35.00,
      type: TransactionType.expense,
      category: TransactionCategory.transportation,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      description: 'Fuel for car',
    ),
    Transaction(
      id: '4',
      title: 'Netflix Subscription',
      amount: 15.99,
      type: TransactionType.expense,
      category: TransactionCategory.entertainment,
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: 'Monthly subscription',
    ),
    Transaction(
      id: '5',
      title: 'Freelance Payment',
      amount: 350.00,
      type: TransactionType.income,
      category: TransactionCategory.freelance,
      date: DateTime.now().subtract(const Duration(days: 3)),
      description: 'Web development project',
    ),
  ];

  final List<Budget> _budgets = [
    Budget(
      id: '1',
      name: 'Groceries',
      category: 'Food',
      amount: 300.0,
      period: BudgetPeriod.monthly,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      spent: 245.20,
    ),
    Budget(
      id: '2',
      name: 'Entertainment',
      category: 'Leisure',
      amount: 150.0,
      period: BudgetPeriod.monthly,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      spent: 89.99,
    ),
    Budget(
      id: '3',
      name: 'Transportation',
      category: 'Transport',
      amount: 200.0,
      period: BudgetPeriod.monthly,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      spent: 156.00,
    ),
  ];

  final List<Goal> _goals = [
    Goal(
      id: '1',
      name: 'Vacation Fund',
      description: 'Save for summer vacation in Europe',
      type: GoalType.savings,
      targetAmount: 1000.0,
      currentAmount: 650.0,
      targetDate: DateTime.now().add(const Duration(days: 60)),
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Goal(
      id: '2',
      name: 'Emergency Fund',
      description: '6 months of living expenses',
      type: GoalType.emergencyFund,
      targetAmount: 5000.0,
      currentAmount: 3200.0,
      targetDate: DateTime.now().add(const Duration(days: 180)),
      createdDate: DateTime.now().subtract(const Duration(days: 90)),
    ),
  ];

  final List<Bill> _bills = [
    Bill(
      id: '1',
      name: 'Electric Bill',
      description: 'Monthly electricity bill',
      amount: 120.00,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
      status: BillStatus.pending,
    ),
    Bill(
      id: '2',
      name: 'Internet Bill',
      description: 'Monthly internet service',
      amount: 89.99,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
      status: BillStatus.pending,
    ),
    Bill(
      id: '3',
      name: 'Phone Bill',
      description: 'Mobile phone service',
      amount: 65.00,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
      status: BillStatus.paid,
    ),
  ];

  final List<Account> _accounts = [
    Account(
      id: '1',
      name: 'Main Checking',
      institution: 'Chase Bank',
      type: AccountType.checking,
      accountNumber: '1234567890',
      balance: 2450.00,
      availableBalance: 2450.00,
      createdDate: DateTime.now().subtract(const Duration(days: 365)),
      lastUpdated: DateTime.now(),
      isDefault: true,
    ),
    Account(
      id: '2',
      name: 'Savings Account',
      institution: 'Chase Bank',
      type: AccountType.savings,
      accountNumber: '0987654321',
      balance: 5200.00,
      availableBalance: 5200.00,
      createdDate: DateTime.now().subtract(const Duration(days: 365)),
      lastUpdated: DateTime.now(),
    ),
    Account(
      id: '3',
      name: 'Credit Card',
      institution: 'Chase Bank',
      type: AccountType.creditCard,
      accountNumber: '5555666677778888',
      balance: -450.00,
      availableBalance: 4550.00,
      createdDate: DateTime.now().subtract(const Duration(days: 180)),
      lastUpdated: DateTime.now(),
      metadata: {'creditLimit': 5000.0},
    ),
  ];

  // New model lists
  final List<CreditScore> _creditScores = [
    CreditScore(
      id: '1',
      score: 742,
      lastUpdated: DateTime.now().subtract(const Duration(days: 7)),
      createdDate: DateTime.now().subtract(const Duration(days: 365)),
      factors: {
        'paymentHistory': 0.35,
        'creditUtilization': 0.30,
        'lengthOfCredit': 0.15,
        'newCredit': 0.10,
        'creditMix': 0.10,
      },
      recommendations: [
        'Pay down credit card balances',
        'Keep credit utilization below 30%',
        'Continue making on-time payments',
      ],
    ),
  ];

  final List<CashFlow> _cashFlows = [
    CashFlow(
      id: '1',
      title: 'Monthly Salary',
      amount: 2500.00,
      type: CashFlowType.income,
      frequency: CashFlowFrequency.monthly,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      category: 'Salary',
      isAutomated: true,
    ),
    CashFlow(
      id: '2',
      title: 'Rent Payment',
      amount: 1200.00,
      type: CashFlowType.expense,
      frequency: CashFlowFrequency.monthly,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      category: 'Housing',
      isAutomated: true,
    ),
  ];

  final List<FinancialTip> _financialTips = [
    FinancialTip(
      id: '1',
      title: 'The 50/30/20 Budget Rule',
      content: 'A simple budgeting method where 50% of your income goes to needs, 30% to wants, and 20% to savings and debt repayment.',
      category: TipCategory.budgeting,
      difficulty: TipDifficulty.beginner,
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
      readTimeMinutes: 3,
      tags: ['budgeting', 'basics', 'rule'],
    ),
    FinancialTip(
      id: '2',
      title: 'Building an Emergency Fund',
      content: 'Learn how to build and maintain a 3-6 month emergency fund for financial security.',
      category: TipCategory.saving,
      difficulty: TipDifficulty.beginner,
      createdDate: DateTime.now().subtract(const Duration(days: 15)),
      readTimeMinutes: 5,
      tags: ['emergency fund', 'saving', 'security'],
    ),
  ];

  final List<SecuritySettings> _securitySettings = [
    SecuritySettings(
      userId: 'user1',
      twoFactorEnabled: false,
      biometricEnabled: true,
      sessionTimeoutEnabled: true,
      sessionTimeoutMinutes: 30,
      loginNotifications: true,
      dataEncryptionEnabled: true,
      lastUpdated: DateTime.now(),
    ),
  ];

  final List<UserSubscription> _subscriptions = [
    UserSubscription(
      id: '1',
      userId: 'user1',
      plan: SubscriptionPlan.free,
      status: SubscriptionStatus.active,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      billingCycle: BillingCycle.monthly,
      price: 0.0,
      autoRenew: true,
      createdDate: DateTime.now().subtract(const Duration(days: 30)),
      lastUpdated: DateTime.now(),
    ),
  ];

  final List<CollaborationGroup> _collaborationGroups = [
    CollaborationGroup(
      id: '1',
      name: 'Family Budget',
      description: 'Shared family financial planning',
      ownerId: 'user1',
      createdDate: DateTime.now().subtract(const Duration(days: 60)),
      members: [
        CollaborationMember(
          id: '1',
          userId: 'user1',
          email: 'user1@example.com',
          name: 'John Doe',
          role: CollaborationRole.owner,
          joinedDate: DateTime.now().subtract(const Duration(days: 60)),
        ),
      ],
    ),
  ];

  final List<CollaborationInvitation> _collaborationInvitations = [
    CollaborationInvitation(
      id: '1',
      groupId: '1',
      groupName: 'Family Budget',
      invitedByUserId: 'user2',
      invitedByName: 'Jane Doe',
      inviteeEmail: 'user1@example.com',
      role: CollaborationRole.editor,
      message: 'Join our family budget planning!',
      sentDate: DateTime.now().subtract(const Duration(days: 2)),
      expiresAt: DateTime.now().add(const Duration(days: 5)),
    ),
  ];

  // Getters
  List<Transaction> get transactions => _transactions;
  List<Budget> get budgets => _budgets;
  List<Goal> get goals => _goals;
  List<Bill> get bills => _bills;
  List<Account> get accounts => _accounts;
  List<CreditScore> get creditScores => _creditScores;
  List<CashFlow> get cashFlows => _cashFlows;
  List<FinancialTip> get financialTips => _financialTips;
  List<SecuritySettings> get securitySettings => _securitySettings;
  List<UserSubscription> get subscriptions => _subscriptions;
  List<CollaborationGroup> get collaborationGroups => _collaborationGroups;
  List<CollaborationInvitation> get collaborationInvitations => _collaborationInvitations;

  // Calculated values
  double get totalBalance {
    return _accounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  double get monthlyIncome {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return _transactions
        .where((t) => t.isIncome && t.date.isAfter(startOfMonth) && t.date.isBefore(endOfMonth))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get monthlyExpenses {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return _transactions
        .where((t) => t.isExpense && t.date.isAfter(startOfMonth) && t.date.isBefore(endOfMonth))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get netWorth {
    return _accounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  // Recent transactions (last 5)
  List<Transaction> get recentTransactions {
    return _transactions
        .where((t) => t.date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Upcoming bills (next 7 days)
  List<Bill> get upcomingBills {
    final nextWeek = DateTime.now().add(const Duration(days: 7));
    return _bills
        .where((bill) => bill.dueDate.isBefore(nextWeek) && !bill.isPaid)
        .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Active budgets
  List<Budget> get activeBudgets {
    return _budgets.where((budget) => budget.isActive).toList();
  }

  // Active goals
  List<Goal> get activeGoals {
    return _goals.where((goal) => goal.status == GoalStatus.active).toList();
  }

  // Add new transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Add new budget
  void addBudget(Budget budget) {
    _budgets.add(budget);
    notifyListeners();
  }

  // Add new goal
  void addGoal(Goal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  // Add new bill
  void addBill(Bill bill) {
    _bills.add(bill);
    notifyListeners();
  }

  // Add new account
  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }

  // Update transaction
  void updateTransaction(String id, Transaction updatedTransaction) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }

  // Update budget
  void updateBudget(String id, Budget updatedBudget) {
    final index = _budgets.indexWhere((b) => b.id == id);
    if (index != -1) {
      _budgets[index] = updatedBudget;
      notifyListeners();
    }
  }

  // Update goal
  void updateGoal(String id, Goal updatedGoal) {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      _goals[index] = updatedGoal;
      notifyListeners();
    }
  }

  // Update bill
  void updateBill(String id, Bill updatedBill) {
    final index = _bills.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bills[index] = updatedBill;
      notifyListeners();
    }
  }

  // Update account
  void updateAccount(String id, Account updatedAccount) {
    final index = _accounts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _accounts[index] = updatedAccount;
      notifyListeners();
    }
  }

  // Delete transaction
  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Delete budget
  void deleteBudget(String id) {
    _budgets.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  // Delete goal
  void deleteGoal(String id) {
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  // Delete bill
  void deleteBill(String id) {
    _bills.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  // Delete account
  void deleteAccount(String id) {
    _accounts.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // ===== NEW MODEL CRUD OPERATIONS =====

  // Credit Score operations
  void addCreditScore(CreditScore creditScore) {
    _creditScores.add(creditScore);
    notifyListeners();
  }

  void updateCreditScore(String id, CreditScore updatedCreditScore) {
    final index = _creditScores.indexWhere((c) => c.id == id);
    if (index != -1) {
      _creditScores[index] = updatedCreditScore;
      notifyListeners();
    }
  }

  void deleteCreditScore(String id) {
    _creditScores.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // Cash Flow operations
  void addCashFlow(CashFlow cashFlow) {
    _cashFlows.add(cashFlow);
    notifyListeners();
  }

  void updateCashFlow(String id, CashFlow updatedCashFlow) {
    final index = _cashFlows.indexWhere((c) => c.id == id);
    if (index != -1) {
      _cashFlows[index] = updatedCashFlow;
      notifyListeners();
    }
  }

  void deleteCashFlow(String id) {
    _cashFlows.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // Financial Tip operations
  void addFinancialTip(FinancialTip tip) {
    _financialTips.add(tip);
    notifyListeners();
  }

  void updateFinancialTip(String id, FinancialTip updatedTip) {
    final index = _financialTips.indexWhere((t) => t.id == id);
    if (index != -1) {
      _financialTips[index] = updatedTip;
      notifyListeners();
    }
  }

  void deleteFinancialTip(String id) {
    _financialTips.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Security Settings operations
  void addSecuritySettings(SecuritySettings settings) {
    _securitySettings.add(settings);
    notifyListeners();
  }

  void updateSecuritySettings(String userId, SecuritySettings updatedSettings) {
    final index = _securitySettings.indexWhere((s) => s.userId == userId);
    if (index != -1) {
      _securitySettings[index] = updatedSettings;
      notifyListeners();
    }
  }

  void deleteSecuritySettings(String userId) {
    _securitySettings.removeWhere((s) => s.userId == userId);
    notifyListeners();
  }

  // Subscription operations
  void addSubscription(UserSubscription subscription) {
    _subscriptions.add(subscription);
    notifyListeners();
  }

  void updateSubscription(String id, UserSubscription updatedSubscription) {
    final index = _subscriptions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _subscriptions[index] = updatedSubscription;
      notifyListeners();
    }
  }

  void deleteSubscription(String id) {
    _subscriptions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // Collaboration operations
  void addCollaborationGroup(CollaborationGroup group) {
    _collaborationGroups.add(group);
    notifyListeners();
  }

  void updateCollaborationGroup(String id, CollaborationGroup updatedGroup) {
    final index = _collaborationGroups.indexWhere((g) => g.id == id);
    if (index != -1) {
      _collaborationGroups[index] = updatedGroup;
      notifyListeners();
    }
  }

  void deleteCollaborationGroup(String id) {
    _collaborationGroups.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  // Collaboration Invitation operations
  void acceptInvitation(String invitationId) {
    final index = _collaborationInvitations.indexWhere((i) => i.id == invitationId);
    if (index != -1) {
      final invitation = _collaborationInvitations[index];
      final updatedInvitation = invitation.copyWith(
        status: InvitationStatus.accepted,
        respondedDate: DateTime.now(),
      );
      _collaborationInvitations[index] = updatedInvitation;

      // Add user to the group
      final groupIndex = _collaborationGroups.indexWhere((g) => g.id == invitation.groupId);
      if (groupIndex != -1) {
        final group = _collaborationGroups[groupIndex];
        final newMember = CollaborationMember(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'user1', // Current user
          email: invitation.inviteeEmail,
          name: 'Current User', // This should come from user profile
          role: invitation.role,
          joinedDate: DateTime.now(),
        );
        final updatedGroup = group.copyWith(
          members: [...group.members, newMember],
        );
        _collaborationGroups[groupIndex] = updatedGroup;
      }

      notifyListeners();
    }
  }

  void declineInvitation(String invitationId) {
    final index = _collaborationInvitations.indexWhere((i) => i.id == invitationId);
    if (index != -1) {
      final invitation = _collaborationInvitations[index];
      final updatedInvitation = invitation.copyWith(
        status: InvitationStatus.declined,
        respondedDate: DateTime.now(),
      );
      _collaborationInvitations[index] = updatedInvitation;
      notifyListeners();
    }
  }

  void deleteInvitation(String invitationId) {
    _collaborationInvitations.removeWhere((i) => i.id == invitationId);
    notifyListeners();
  }

  // ===== CALCULATED VALUES FOR NEW FEATURES =====

  // Get current credit score
  CreditScore? get currentCreditScore {
    return _creditScores.isNotEmpty ? _creditScores.first : null;
  }

  // Get cash flow projections for next 30 days
  List<CashFlowProjection> get cashFlowProjections {
    final projections = <CashFlowProjection>[];
    final now = DateTime.now();

    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      final dayFlows = _cashFlows.where((flow) {
        if (!flow.isActive) return false;
        final nextOccurrence = flow.getNextOccurrence();
        return nextOccurrence != null && nextOccurrence.day == date.day;
      }).toList();

      final income = dayFlows
          .where((flow) => flow.isIncome)
          .fold(0.0, (sum, flow) => sum + flow.amount);

      final expenses = dayFlows
          .where((flow) => flow.isExpense)
          .fold(0.0, (sum, flow) => sum + flow.amount);

      projections.add(CashFlowProjection(
        date: date,
        projectedIncome: income,
        projectedExpenses: expenses,
        netFlow: income - expenses,
        contributingFlows: dayFlows,
      ));
    }

    return projections;
  }

  // Get unread financial tips
  List<FinancialTip> get unreadTips {
    return _financialTips.where((tip) => !tip.isPremium).toList();
  }

  // Get premium tips (for subscribed users)
  List<FinancialTip> get premiumTips {
    return _financialTips.where((tip) => tip.isPremium).toList();
  }

  // Get current subscription
  UserSubscription? get currentSubscription {
    return _subscriptions.isNotEmpty ? _subscriptions.first : null;
  }

  // Get user's collaboration groups
  List<CollaborationGroup> get userCollaborationGroups {
    return _collaborationGroups.where((group) =>
      group.members.any((member) => member.userId == 'user1')
    ).toList();
  }

  // Get security events (mock data for demo)
  List<SecurityEvent> get securityEvents {
    return [
      SecurityEvent(
        id: '1',
        userId: 'user1',
        type: SecurityEventType.login,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Successful login from Chrome on Windows',
        ipAddress: '192.168.1.100',
        deviceInfo: 'Chrome 120.0.0.0',
      ),
      SecurityEvent(
        id: '2',
        userId: 'user1',
        type: SecurityEventType.passwordChange,
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        description: 'Password changed successfully',
      ),
    ];
  }

  // ===== SUBSCRIPTION MANAGEMENT =====

  // Cancel subscription
  Future<void> cancelSubscription(String reason) async {
    if (_subscriptions.isNotEmpty) {
      final subscription = _subscriptions.first;
      final updatedSubscription = subscription.copyWith(
        status: SubscriptionStatus.cancelled,
        cancellationReason: reason,
        lastUpdated: DateTime.now(),
      );
      updateSubscription(subscription.id, updatedSubscription);
    }
  }

  // Pause subscription
  Future<void> pauseSubscription() async {
    if (_subscriptions.isNotEmpty) {
      final subscription = _subscriptions.first;
      final updatedSubscription = subscription.copyWith(
        status: SubscriptionStatus.paused,
        lastUpdated: DateTime.now(),
      );
      updateSubscription(subscription.id, updatedSubscription);
    }
  }

  // Resume subscription
  Future<void> resumeSubscription() async {
    if (_subscriptions.isNotEmpty) {
      final subscription = _subscriptions.first;
      final updatedSubscription = subscription.copyWith(
        status: SubscriptionStatus.active,
        lastUpdated: DateTime.now(),
      );
      updateSubscription(subscription.id, updatedSubscription);
    }
  }

  // Upgrade subscription
  Future<void> upgradeSubscription(SubscriptionPlan newPlan) async {
    if (_subscriptions.isNotEmpty) {
      final subscription = _subscriptions.first;
      final planDetails = SubscriptionPlanDetails.getPlanDetails(newPlan);
      final updatedSubscription = subscription.copyWith(
        plan: newPlan,
        price: planDetails.price,
        lastUpdated: DateTime.now(),
      );
      updateSubscription(subscription.id, updatedSubscription);
    }
  }

  // Subscribe to new plan
  Future<void> subscribeToPlan(SubscriptionPlan plan) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    final planDetails = SubscriptionPlanDetails.getPlanDetails(plan);
    final newSubscription = UserSubscription(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user1',
      plan: plan,
      status: SubscriptionStatus.active,
      startDate: DateTime.now(),
      billingCycle: planDetails.billingCycle,
      price: planDetails.price,
      autoRenew: true,
      createdDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );

    // Remove existing subscription and add new one
    _subscriptions.clear();
    _subscriptions.add(newSubscription);
    notifyListeners();
  }

  // ===== CREDIT SCORE REFRESH =====

  // Refresh credit score data (simulated API call)
  Future<void> refreshCreditScore() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (_creditScores.isNotEmpty) {
      final currentScore = _creditScores.first;
      final newScore = _generateNewCreditScore(currentScore.score);

      // Create updated credit score with new data
      final updatedScore = currentScore.copyWith(
        score: newScore,
        lastUpdated: DateTime.now(),
        factors: _generateUpdatedFactors(),
        recommendations: _generateRecommendations(newScore),
        history: [
          ...currentScore.history,
          CreditScoreHistory(
            date: DateTime.now(),
            score: newScore,
            event: 'Score refreshed',
          ),
        ].take(10).toList(), // Keep only last 10 history entries
      );

      // Update the credit score
      updateCreditScore(currentScore.id, updatedScore);
    }
  }

  // Generate a new credit score (simulated)
  int _generateNewCreditScore(int currentScore) {
    // Simulate small random changes (-10 to +10 points)
    final change = (DateTime.now().millisecondsSinceEpoch % 21) - 10;
    final newScore = (currentScore + change).clamp(300, 850);
    return newScore;
  }

  // Generate updated factors based on new score
  Map<String, dynamic> _generateUpdatedFactors() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return {
      'paymentHistory': 0.30 + (random % 10) / 100, // 0.30-0.40
      'creditUtilization': 0.25 + (random % 15) / 100, // 0.25-0.40
      'lengthOfCredit': 0.15 + (random % 10) / 100, // 0.15-0.25
      'newCredit': 0.08 + (random % 7) / 100, // 0.08-0.15
      'creditMix': 0.12 + (random % 8) / 100, // 0.12-0.20
    };
  }

  // Generate recommendations based on score
  List<String> _generateRecommendations(int score) {
    final recommendations = <String>[];

    if (score < 670) {
      recommendations.addAll([
        'Pay down credit card balances',
        'Make all payments on time',
        'Keep credit utilization below 30%',
        'Avoid opening new credit accounts',
      ]);
    } else if (score < 740) {
      recommendations.addAll([
        'Continue making on-time payments',
        'Keep credit utilization low',
        'Consider becoming an authorized user',
      ]);
    } else {
      recommendations.addAll([
        'Maintain excellent payment history',
        'Keep credit utilization below 30%',
        'Monitor your credit regularly',
      ]);
    }

    return recommendations.take(3).toList(); // Return top 3 recommendations
  }
}