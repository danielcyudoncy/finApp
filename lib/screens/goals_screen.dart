// screens/goals_screen.dart
import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
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
          _buildGoalCard(
            'Vacation Fund',
            1000,
            650,
            'Save for summer vacation',
            Icons.beach_access,
            Colors.blue,
          ),
          _buildGoalCard(
            'Emergency Fund',
            5000,
            3200,
            '6 months of expenses',
            Icons.security,
            Colors.green,
          ),
          _buildGoalCard(
            'New Car',
            15000,
            8500,
            'Down payment for new car',
            Icons.directions_car,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
    String title,
    double target,
    double saved,
    String description,
    IconData icon,
    Color color,
  ) {
    double progress = saved / target;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        description,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${saved.toStringAsFixed(0)} / \$${target.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% complete',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}