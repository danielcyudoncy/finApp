// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fin_app/providers/finance_provider.dart';
import 'package:fin_app/screens/dashboard_screen.dart';
import 'package:fin_app/screens/transactions_screen.dart';
import 'package:fin_app/screens/budget_screen.dart';
import 'package:fin_app/screens/goals_screen.dart';
import 'package:fin_app/screens/profile_screen.dart';
import 'package:fin_app/screens/credit_score_screen.dart';
import 'package:fin_app/screens/cash_flow_screen.dart';
import 'package:fin_app/screens/financial_tips_screen.dart';
import 'package:fin_app/screens/security_screen.dart';
import 'package:fin_app/screens/collaboration_screen.dart';
import 'package:fin_app/screens/subscription_screen.dart';
import 'package:fin_app/screens/more_screen.dart';

void main() {
  runApp(const FinApp());
}

class FinApp extends StatelessWidget {
  const FinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FinanceProvider(),
      child: MaterialApp(
        title: 'Finance & Budget Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionsScreen(),
    const BudgetScreen(),
    const GoalsScreen(),
    const MoreScreen(),
    const CreditScoreScreen(),
    const CashFlowScreen(),
    const FinancialTipsScreen(),
    const SecurityScreen(),
    const CollaborationScreen(),
    const SubscriptionScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_balance_wallet),
      label: 'Transactions',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.pie_chart),
      label: 'Budget',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.flag),
      label: 'Goals',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.more_horiz),
      label: 'More',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
