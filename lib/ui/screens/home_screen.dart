import 'package:everyday_risk_analyzer/data/mock_risks.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/models/user.dart';
import 'package:everyday_risk_analyzer/ui/screens/calendar_screen.dart';
import 'package:everyday_risk_analyzer/ui/screens/profile_screen.dart';
import 'package:everyday_risk_analyzer/ui/screens/risk_analytics.dart';
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
  List<RiskEntry> _risks = [];
  UserProfile? _profile;
  int selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final risks = await StorageService.loadRisks();
    final profile = await StorageService.loadProfile();
    setState(() {
      _risks = risks;
      _profile = profile;
      _isLoading = false;
    });
  }

  // void _onRiskAdded() {
  //   _loadData();
  // }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _profile == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: [
          WeeklySummaryScreen(
            key: ValueKey(0),
            risks: _risks,
            onRefresh: _loadData,
          ),
          RiskOverviewScreen(key: ValueKey(1), risks: _risks),
          CalendarScreen(key: ValueKey(2), risks: _risks),
          ProfileScreen(
            key: ValueKey(3),
            profile: _profile!,
            onThemeChange: widget.onThemeChange,
            onProfileUpdated: _loadData,
          ),
        ][selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
