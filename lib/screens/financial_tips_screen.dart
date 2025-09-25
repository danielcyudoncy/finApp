// screens/financial_tips_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fin_app/providers/finance_provider.dart';
import 'package:fin_app/models/financial_tip.dart';

class FinancialTipsScreen extends StatelessWidget {
  const FinancialTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final tips = provider.unreadTips;
        final premiumTips = provider.premiumTips;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Financial Tips'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearchDialog(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildCategoriesGrid(),
                const SizedBox(height: 24),

                // Latest Tips
                Text(
                  'Latest Tips',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) => _buildTipsList(context, tips),
                ),
                const SizedBox(height: 24),

                // Premium Tips (if subscribed)
                if (premiumTips.isNotEmpty) ...[
                  Text(
                    'Premium Tips',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) => _buildTipsList(context, premiumTips),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = TipCategory.values;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Builder(
          builder: (context) => _buildCategoryCard(context, category),
        );
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, TipCategory category) {
    return Card(
      child: InkWell(
        onTap: () => _navigateToCategoryTips(context, category),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(category),
                size: 32,
                color: _getCategoryColor(category),
              ),
              const SizedBox(height: 8),
              Text(
                _getCategoryName(category),
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsList(BuildContext context, List<FinancialTip> tips) {
    if (tips.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No tips available'),
        ),
      );
    }

    return Column(
      children: tips.map((tip) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: tip.categoryColor.withOpacity(0.1),
              child: Icon(tip.categoryIcon, color: tip.categoryColor),
            ),
            title: Text(tip.title),
            subtitle: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: tip.difficultyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tip.difficultyText,
                    style: TextStyle(
                      color: tip.difficultyColor,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${tip.readTimeMinutes} min read'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _navigateToTipDetail(context, tip),
          ),
        );
      }).toList(),
    );
  }

  IconData _getCategoryIcon(TipCategory category) {
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

  Color _getCategoryColor(TipCategory category) {
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

  String _getCategoryName(TipCategory category) {
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

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Tips'),
          content: const Text('Search functionality would be implemented here. This would include searching through financial tips by keywords, categories, and difficulty levels.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToCategoryTips(BuildContext context, TipCategory category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${_getCategoryName(category)} Tips'),
          content: Text('Category tips screen would be implemented here. This would show all tips in the ${_getCategoryName(category)} category with filtering and sorting options.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToTipDetail(BuildContext context, FinancialTip tip) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tip.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tip.content),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: tip.difficultyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tip.difficultyText,
                      style: TextStyle(
                        color: tip.difficultyColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${tip.readTimeMinutes} min read'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}