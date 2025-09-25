// screens/credit_score_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fin_app/providers/finance_provider.dart';
import 'package:fin_app/models/credit_score.dart';

class CreditScoreScreen extends StatefulWidget {
  const CreditScoreScreen({super.key});

  @override
  State<CreditScoreScreen> createState() => _CreditScoreScreenState();
}

class _CreditScoreScreenState extends State<CreditScoreScreen> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final creditScore = provider.currentCreditScore;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Credit Score'),
            actions: [
              IconButton(
                icon: _isRefreshing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.refresh),
                onPressed: _isRefreshing ? null : _refreshCreditScore,
              ),
            ],
          ),
          body: creditScore == null
              ? const Center(
                  child: Text('No credit score data available'),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Credit Score Card
                      _buildCreditScoreCard(creditScore),
                      const SizedBox(height: 24),

                      // Factors Breakdown
                      Text(
                        'Score Factors',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildFactorsBreakdown(creditScore),
                      const SizedBox(height: 24),

                      // Recommendations
                      Text(
                        'Recommendations',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildRecommendations(creditScore),
                      const SizedBox(height: 24),

                      // History
                      Text(
                        'Score History',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildScoreHistory(creditScore),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Future<void> _refreshCreditScore() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      final provider = Provider.of<FinanceProvider>(context, listen: false);
      await provider.refreshCreditScore();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credit score refreshed successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh credit score: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Widget _buildCreditScoreCard(CreditScore creditScore) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              creditScore.rangeColor.withOpacity(0.1),
              creditScore.rangeColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.score,
              size: 48,
              color: creditScore.rangeColor,
            ),
            const SizedBox(height: 16),
            Text(
              creditScore.score.toString(),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              creditScore.rangeText,
              style: TextStyle(
                fontSize: 18,
                color: creditScore.rangeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${creditScore.lastUpdated.day}/${creditScore.lastUpdated.month}/${creditScore.lastUpdated.year}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorsBreakdown(CreditScore creditScore) {
    final factors = creditScore.factors.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: factors.map((factor) {
        final percentage = (factor.value * 100).toInt();
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
                      _getFactorName(factor.key),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$percentage%'),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: factor.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage >= 30 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendations(CreditScore creditScore) {
    if (creditScore.recommendations.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No recommendations available'),
        ),
      );
    }

    return Column(
      children: creditScore.recommendations.map((recommendation) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.lightbulb, color: Colors.amber),
            title: Text(recommendation),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScoreHistory(CreditScore creditScore) {
    if (creditScore.history.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No score history available'),
        ),
      );
    }

    return Column(
      children: creditScore.history.take(5).map((entry) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getScoreChangeColor(entry.score, creditScore.score),
              child: Icon(
                _getScoreChangeIcon(entry.score, creditScore.score),
                color: Colors.white,
              ),
            ),
            title: Text('Score: ${entry.score}'),
            subtitle: Text(entry.event),
            trailing: Text(
              '${entry.date.day}/${entry.date.month}/${entry.date.year}',
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getFactorName(String key) {
    switch (key) {
      case 'paymentHistory':
        return 'Payment History';
      case 'creditUtilization':
        return 'Credit Utilization';
      case 'lengthOfCredit':
        return 'Length of Credit History';
      case 'newCredit':
        return 'New Credit';
      case 'creditMix':
        return 'Credit Mix';
      default:
        return key;
    }
  }

  Color _getScoreChangeColor(int oldScore, int newScore) {
    if (oldScore > newScore) return Colors.red;
    if (oldScore < newScore) return Colors.green;
    return Colors.grey;
  }

  IconData _getScoreChangeIcon(int oldScore, int newScore) {
    if (oldScore > newScore) return Icons.arrow_downward;
    if (oldScore < newScore) return Icons.arrow_upward;
    return Icons.horizontal_rule;
  }
}