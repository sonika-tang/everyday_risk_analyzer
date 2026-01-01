import 'package:everyday_risk_analyzer/data/mock_risks.dart';
import 'package:everyday_risk_analyzer/models/user.dart';
import 'package:everyday_risk_analyzer/ui/screens/splash_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const RiskAnalysisApp());
}

class RiskAnalysisApp extends StatefulWidget {
  const RiskAnalysisApp({super.key});

  @override
  State<RiskAnalysisApp> createState() => _RiskAnalysisAppState();
}

class _RiskAnalysisAppState extends State<RiskAnalysisApp> {
  UserProfile? _profile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final profile = await StorageService.loadProfile();
    setState(() {
      _profile = profile;
      _isLoadingProfile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile || _profile == null) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Risk Analysis',
      theme: _profile!.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: SplashScreen(onThemeChange: _loadProfile),
      debugShowCheckedModeBanner: false,
    );
  }
}
