// screens/bills_screen.dart
import 'package:flutter/material.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills'),
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
          _buildBillCard(
            'Electric Bill',
            '\$120.00',
            'Due in 3 days',
            Icons.electric_bolt,
            Colors.yellow,
            true,
          ),
          _buildBillCard(
            'Internet',
            '\$89.99',
            'Due in 7 days',
            Icons.wifi,
            Colors.blue,
            false,
          ),
          _buildBillCard(
            'Credit Card',
            '\$450.00',
            'Due in 12 days',
            Icons.credit_card,
            Colors.purple,
            false,
          ),
          _buildBillCard(
            'Phone Bill',
            '\$65.00',
            'Paid',
            Icons.phone,
            Colors.green,
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(
    String title,
    String amount,
    String status,
    IconData icon,
    Color color,
    bool isPaid,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(status),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPaid ? 'Paid' : 'Pending',
                style: TextStyle(
                  color: isPaid ? Colors.green : Colors.orange,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}