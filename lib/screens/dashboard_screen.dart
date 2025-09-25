// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fin_app/providers/finance_provider.dart';
import 'package:fin_app/models/transaction.dart';
import 'package:fin_app/models/budget.dart';
import 'package:fin_app/models/bill.dart';
import 'package:fin_app/models/goal.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Financial Overview Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildOverviewCard(
                        context,
                        'Total Balance',
                        '\$${provider.totalBalance.toStringAsFixed(2)}',
                        Icons.account_balance_wallet,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildOverviewCard(
                        context,
                        'Net Worth',
                        '\$${provider.netWorth.toStringAsFixed(2)}',
                        Icons.trending_up,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildOverviewCard(
                        context,
                        'Monthly Income',
                        '\$${provider.monthlyIncome.toStringAsFixed(2)}',
                        Icons.arrow_upward,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildOverviewCard(
                        context,
                        'Monthly Expenses',
                        '\$${provider.monthlyExpenses.toStringAsFixed(2)}',
                        Icons.arrow_downward,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'Add Transaction',
                        Icons.add,
                        () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'Create Budget',
                        Icons.pie_chart,
                        () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'Set Goal',
                        Icons.flag,
                        () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'Add Bill',
                        Icons.receipt,
                        () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Budget Overview
                Text(
                  'Budget Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildBudgetOverview(provider.activeBudgets),
                const SizedBox(height: 32),

                // Upcoming Bills
                Text(
                  'Upcoming Bills',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildUpcomingBills(provider.upcomingBills),
                const SizedBox(height: 32),

                // Recent Transactions
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildTransactionListFromProvider(provider.recentTransactions),
                const SizedBox(height: 32),

                // Goals Progress
                Text(
                  'Goals Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildGoalsOverview(provider.activeGoals),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String amount,
    String date,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(
          color: amount.startsWith('-') ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBudgetOverview(List<Budget> budgets) {
    if (budgets.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No active budgets'),
        ),
      );
    }

    return Column(
      children: budgets.map((budget) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      budget.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${budget.spent.toStringAsFixed(0)} / \$${budget.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: budget.isOverBudget ? Colors.red : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: budget.progress > 1.0 ? 1.0 : budget.progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    budget.isOverBudget ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(budget.progress * 100).toStringAsFixed(0)}% used',
                  style: TextStyle(
                    color: budget.isOverBudget ? Colors.red : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpcomingBills(List<Bill> bills) {
    if (bills.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No upcoming bills'),
        ),
      );
    }

    return Column(
      children: bills.take(3).map((bill) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: bill.statusColor.withOpacity(0.1),
              child: Icon(bill.statusIcon, color: bill.statusColor),
            ),
            title: Text(bill.name),
            subtitle: Text(
              'Due: ${bill.dueDate.day}/${bill.dueDate.month}/${bill.dueDate.year}',
            ),
            trailing: Text(
              '\$${bill.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTransactionListFromProvider(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No recent transactions'),
        ),
      );
    }

    return Column(
      children: transactions.take(5).map((transaction) {
        return _buildTransactionItem(
          transaction.title,
          '${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
          transaction.categoryIcon,
          transaction.categoryColor,
        );
      }).toList(),
    );
  }

  Widget _buildGoalsOverview(List<Goal> goals) {
    if (goals.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No active goals'),
        ),
      );
    }

    return Column(
      children: goals.map((goal) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(goal.typeIcon, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        goal.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(goal.progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: goal.progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${goal.currentAmount.toStringAsFixed(0)} / \$${goal.targetAmount.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}