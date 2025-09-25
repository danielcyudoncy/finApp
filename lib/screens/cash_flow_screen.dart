// screens/cash_flow_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fin_app/providers/finance_provider.dart';
import 'package:fin_app/models/cash_flow.dart';

class CashFlowScreen extends StatelessWidget {
  const CashFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final projections = provider.cashFlowProjections;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cash Flow'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddCashFlowDialog(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cash Flow Summary
                _buildCashFlowSummary(projections),
                const SizedBox(height: 24),

                // 30-Day Projection
                Text(
                  '30-Day Projection',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildProjectionChart(projections),
                const SizedBox(height: 24),

                // Active Cash Flows
                Text(
                  'Active Cash Flows',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildCashFlowsList(provider.cashFlows),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCashFlowSummary(List<CashFlowProjection> projections) {
    final totalIncome = projections.fold(0.0, (sum, p) => sum + p.projectedIncome);
    final totalExpenses = projections.fold(0.0, (sum, p) => sum + p.projectedExpenses);
    final netFlow = totalIncome - totalExpenses;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Income',
            '\$${totalIncome.toStringAsFixed(2)}',
            Icons.arrow_upward,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Total Expenses',
            '\$${totalExpenses.toStringAsFixed(2)}',
            Icons.arrow_downward,
            Colors.red,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Net Flow',
            '\$${netFlow.toStringAsFixed(2)}',
            netFlow >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
            netFlow >= 0 ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
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
              amount,
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

  Widget _buildProjectionChart(List<CashFlowProjection> projections) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Daily Cash Flow'),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: projections.length,
                itemBuilder: (context, index) {
                  final projection = projections[index];
                  return Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: 40,
                            decoration: BoxDecoration(
                              color: projection.isPositive ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  projection.netFlow.toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${projection.date.day}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashFlowsList(List<CashFlow> cashFlows) {
    if (cashFlows.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No active cash flows'),
        ),
      );
    }

    return Column(
      children: cashFlows.map((flow) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: flow.typeColor.withValues(alpha: 0.1),
              child: Icon(flow.typeIcon, color: flow.typeColor),
            ),
            title: Text(flow.title),
            subtitle: Text(flow.frequencyText),
            trailing: Text(
              '${flow.isIncome ? '+' : '-'}\$${flow.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: flow.isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showAddCashFlowDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();

    CashFlowType selectedType = CashFlowType.income;
    CashFlowFrequency selectedFrequency = CashFlowFrequency.monthly;
    DateTime selectedStartDate = DateTime.now();
    bool isAutomated = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Cash Flow'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title field
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title *',
                          hintText: 'e.g., Monthly Salary, Rent Payment',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Amount field
                      TextFormField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount *',
                          hintText: '0.00',
                          prefixText: '\$',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Amount is required';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid positive amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Type dropdown
                      DropdownButtonFormField<CashFlowType>(
                        value: selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Type *',
                        ),
                        items: CashFlowType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(_getCashFlowTypeText(type)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Frequency dropdown
                      DropdownButtonFormField<CashFlowFrequency>(
                        value: selectedFrequency,
                        decoration: const InputDecoration(
                          labelText: 'Frequency *',
                        ),
                        items: CashFlowFrequency.values.map((frequency) {
                          return DropdownMenuItem(
                            value: frequency,
                            child: Text(_getCashFlowFrequencyText(frequency)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFrequency = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Start date picker
                      InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedStartDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedStartDate = pickedDate;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Date *',
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}',
                              ),
                              const Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Category field
                      TextFormField(
                        controller: categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          hintText: 'e.g., Salary, Housing, Food',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description field
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Optional description',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Automated checkbox
                      CheckboxListTile(
                        title: const Text('Automated'),
                        subtitle: const Text('This cash flow is automated (e.g., direct deposit)'),
                        value: isAutomated,
                        onChanged: (value) {
                          setState(() {
                            isAutomated = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _addCashFlow(
                        context,
                        title: titleController.text,
                        amount: double.parse(amountController.text),
                        type: selectedType,
                        frequency: selectedFrequency,
                        startDate: selectedStartDate,
                        category: categoryController.text.isEmpty ? null : categoryController.text,
                        description: descriptionController.text.isEmpty ? null : descriptionController.text,
                        isAutomated: isAutomated,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getCashFlowTypeText(CashFlowType type) {
    switch (type) {
      case CashFlowType.income:
        return 'Income';
      case CashFlowType.expense:
        return 'Expense';
      case CashFlowType.transfer:
        return 'Transfer';
      case CashFlowType.investment:
        return 'Investment';
      case CashFlowType.loan:
        return 'Loan';
    }
  }

  String _getCashFlowFrequencyText(CashFlowFrequency frequency) {
    switch (frequency) {
      case CashFlowFrequency.oneTime:
        return 'One-time';
      case CashFlowFrequency.daily:
        return 'Daily';
      case CashFlowFrequency.weekly:
        return 'Weekly';
      case CashFlowFrequency.monthly:
        return 'Monthly';
      case CashFlowFrequency.quarterly:
        return 'Quarterly';
      case CashFlowFrequency.yearly:
        return 'Yearly';
    }
  }

  void _addCashFlow(
    BuildContext context, {
    required String title,
    required double amount,
    required CashFlowType type,
    required CashFlowFrequency frequency,
    required DateTime startDate,
    String? category,
    String? description,
    bool isAutomated = false,
  }) {
    final provider = Provider.of<FinanceProvider>(context, listen: false);

    // Generate a unique ID
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final newCashFlow = CashFlow(
      id: id,
      title: title,
      amount: amount,
      type: type,
      frequency: frequency,
      startDate: startDate,
      category: category,
      description: description,
      isAutomated: isAutomated,
    );

    provider.addCashFlow(newCashFlow);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cash flow "$title" added successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}