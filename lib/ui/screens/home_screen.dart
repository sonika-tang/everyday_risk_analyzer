import 'package:everyday_risk_analyzer/data/mock_risks.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/screens/add_risk_screen.dart';
import 'package:everyday_risk_analyzer/ui/screens/calendar_screen.dart';
import 'package:everyday_risk_analyzer/ui/screens/profile_screen.dart';
import 'package:everyday_risk_analyzer/ui/screens/risk_overview_screen.dart';
import 'package:everyday_risk_analyzer/ui/screens/weekly_summary_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeChange;

  const HomeScreen({super.key, required this.onThemeChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<RiskEntry>> futureRisks;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureRisks = StorageService.loadRisks();
  }

  void _refreshRisks() {
    setState(() => futureRisks = StorageService.loadRisks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<RiskEntry>>( // Check doc for more about FutureBuilder
        future: futureRisks,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<RiskEntry> risks = snapshot.data!;

          return [
            WeeklySummaryScreen(risks: risks, onRefresh: _refreshRisks),
            RiskOverviewScreen(risks: risks), // Still working on
            CalendarScreen(risks: risks), // Still working on
            AddRiskScreen(onRiskAdded: _refreshRisks),
            ProfileScreen(onThemeChange: widget.onThemeChange),
          ][selectedIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Risk',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
