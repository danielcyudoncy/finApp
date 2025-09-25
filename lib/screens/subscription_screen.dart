// screens/subscription_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fin_app/providers/finance_provider.dart';
import 'package:fin_app/models/subscription.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final subscription = provider.currentSubscription;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Subscription'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Subscription
                if (subscription != null) ...[
                  Text(
                    'Current Plan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildCurrentSubscription(subscription),
                  const SizedBox(height: 24),
                ],

                // Available Plans
                Text(
                  'Available Plans',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildPlansGrid(),
                const SizedBox(height: 24),

                // Usage Stats
                Text(
                  'Usage Statistics',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildUsageStats(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentSubscription(UserSubscription subscription) {
    final planDetails = subscription.planDetails;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planDetails.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        planDetails.description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Status: ${subscription.status.name.toUpperCase()}',
                        style: TextStyle(
                          color: subscription.isActive ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subscription.isTrial) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${subscription.trialDaysRemaining} days remaining in trial',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${planDetails.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/${planDetails.billingCycle.name}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (subscription.autoRenew)
              Builder(
                builder: (context) => OutlinedButton(
                  onPressed: () => _showSubscriptionManagementDialog(context),
                  child: const Text('Manage Subscription'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3,
      ),
      itemCount: SubscriptionPlanDetails.allPlans.length,
      itemBuilder: (context, index) {
        final plan = SubscriptionPlanDetails.allPlans[index];
        return _buildPlanCard(plan);
      },
    );
  }

  Widget _buildPlanCard(SubscriptionPlanDetails plan) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.description,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Text(
                  plan.price == 0 ? 'FREE' : '\$${plan.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Features:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: plan.features.take(3).length,
                      itemBuilder: (context, index) {
                        return Text(
                          '• ${plan.features[index]}',
                          style: const TextStyle(fontSize: 11),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Builder(
              builder: (context) => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: plan.price == 0 ? null : () => _subscribeToPlan(context, plan.plan),
                  child: Text(plan.price == 0 ? 'Current Plan' : 'Upgrade'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageStats() {
    return Column(
      children: [
        _buildUsageStat('Transactions', '45/100', 0.45),
        _buildUsageStat('Budgets', '2/3', 0.67),
        _buildUsageStat('Goals', '2/5', 0.4),
        _buildUsageStat('Storage', '150MB/1GB', 0.15),
      ],
    );
  }

  Widget _buildUsageStat(String label, String value, double progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Text(value),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.8 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionManagementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Manage Subscription'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.pause, color: Colors.orange),
                title: const Text('Pause Subscription'),
                subtitle: const Text('Temporarily suspend your subscription'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final provider = Provider.of<FinanceProvider>(context, listen: false);
                  await provider.pauseSubscription();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subscription paused successfully')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Cancel Subscription'),
                subtitle: const Text('Cancel your subscription permanently'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final provider = Provider.of<FinanceProvider>(context, listen: false);
                  await provider.cancelSubscription('User requested cancellation');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subscription cancelled successfully')),
                  );
                },
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

  void _subscribeToPlan(BuildContext context, SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Subscribe to ${SubscriptionPlanDetails.getPlanDetails(plan).name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are about to upgrade to the ${SubscriptionPlanDetails.getPlanDetails(plan).name} plan.'),
              const SizedBox(height: 16),
              Text(
                'Price: \$${SubscriptionPlanDetails.getPlanDetails(plan).price.toStringAsFixed(2)}/${SubscriptionPlanDetails.getPlanDetails(plan).billingCycle.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('This will replace your current subscription.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final provider = Provider.of<FinanceProvider>(context, listen: false);
                try {
                  await provider.subscribeToPlan(plan);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Successfully subscribed to ${SubscriptionPlanDetails.getPlanDetails(plan).name}!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to subscribe: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}