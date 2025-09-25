// screens/budget_screen.dart
import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBudgetCategory('Groceries', 300, 245, Colors.orange),
          _buildBudgetCategory('Entertainment', 150, 89, Colors.purple),
          _buildBudgetCategory('Transportation', 200, 156, Colors.blue),
          _buildBudgetCategory('Dining Out', 100, 67, Colors.red),
          _buildBudgetCategory('Shopping', 250, 189, Colors.green),
        ],
      ),
    );
  }

  Widget _buildBudgetCategory(String name, double budget, double spent, Color color) {
    double progress = spent / budget;
    bool isOverBudget = progress > 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${spent.toStringAsFixed(0)} / \$${budget.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: isOverBudget ? Colors.red : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? Colors.red : color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% used',
              style: TextStyle(
                color: isOverBudget ? Colors.red : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}