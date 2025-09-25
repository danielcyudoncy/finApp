// screens/more_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fin_app/providers/finance_provider.dart';
import 'package:fin_app/screens/credit_score_screen.dart';
import 'package:fin_app/screens/cash_flow_screen.dart';
import 'package:fin_app/screens/financial_tips_screen.dart';
import 'package:fin_app/screens/security_screen.dart';
import 'package:fin_app/screens/collaboration_screen.dart';
import 'package:fin_app/screens/subscription_screen.dart';
import 'package:fin_app/screens/profile_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('More Features'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Financial Tools
                Text(
                  'Financial Tools',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildFeatureGrid([
                  _buildFeatureItem(
                    context,
                    'Credit Score',
                    Icons.score,
                    Colors.orange,
                    onTap: () => _navigateToScreen(context, 5),
                  ),
                  _buildFeatureItem(
                    context,
                    'Cash Flow',
                    Icons.trending_up,
                    Colors.blue,
                    onTap: () => _navigateToScreen(context, 6),
                  ),
                  _buildFeatureItem(
                    context,
                    'Financial Tips',
                    Icons.lightbulb,
                    Colors.amber,
                    onTap: () => _navigateToScreen(context, 7),
                  ),
                  _buildFeatureItem(
                    context,
                    'Security',
                    Icons.security,
                    Colors.green,
                    onTap: () => _navigateToScreen(context, 8),
                  ),
                ]),
                const SizedBox(height: 24),

                // Account & Settings
                Text(
                  'Account & Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildFeatureGrid([
                  _buildFeatureItem(
                    context,
                    'Collaboration',
                    Icons.group,
                    Colors.purple,
                    onTap: () => _navigateToScreen(context, 9),
                  ),
                  _buildFeatureItem(
                    context,
                    'Subscription',
                    Icons.card_membership,
                    Colors.indigo,
                    onTap: () => _navigateToScreen(context, 10),
                  ),
                  _buildFeatureItem(
                    context,
                    'Profile',
                    Icons.person,
                    Colors.teal,
                    onTap: () => _navigateToScreen(context, 11),
                  ),
                  _buildFeatureItem(
                    context,
                    'Settings',
                    Icons.settings,
                    Colors.grey,
                    onTap: () => _navigateToSettings(context),
                  ),
                ]),
                const SizedBox(height: 24),

                // Quick Stats
                Text(
                  'Quick Stats',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildStatsCards(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureGrid(List<Widget> items) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: items,
    );
  }

  Widget _buildFeatureItem(BuildContext context, String title, IconData icon, Color color, {VoidCallback? onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(FinanceProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Credit Score',
                provider.currentCreditScore?.score.toString() ?? 'N/A',
                Icons.score,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Active Goals',
                provider.activeGoals.length.toString(),
                Icons.flag,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Security Status',
                provider.securitySettings.first.isSecure ? 'Secure' : 'Check',
                Icons.security,
                provider.securitySettings.first.isSecure ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Subscription',
                provider.currentSubscription?.plan.name ?? 'Free',
                Icons.card_membership,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int screenIndex) {
    Widget screen;
    switch (screenIndex) {
      case 5:
        screen = const CreditScoreScreen();
        break;
      case 6:
        screen = const CashFlowScreen();
        break;
      case 7:
        screen = const FinancialTipsScreen();
        break;
      case 8:
        screen = const SecurityScreen();
        break;
      case 9:
        screen = const CollaborationScreen();
        break;
      case 10:
        screen = const SubscriptionScreen();
        break;
      case 11:
        screen = const ProfileScreen();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation to screen $screenIndex'),
            duration: const Duration(seconds: 1),
          ),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _navigateToSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: const Text('Settings screen would be implemented here. This would include app preferences, notification settings, theme selection, and other configuration options.'),
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