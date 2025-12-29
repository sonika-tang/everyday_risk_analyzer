import 'package:everyday_risk_analyzer/data/mock_risks.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
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
  late Future<UserProfile> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = StorageService.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    // Still research more on FutureBuilder
    return FutureBuilder<UserProfile>(
      future: futureProfile,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }

        UserProfile profile = snapshot.data!;

        return MaterialApp(
          title: 'Risk Analysis',
          theme: profile.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: SplashScreen(
            onThemeChange: () => setState(() {
              futureProfile = StorageService.loadProfile();
            }),
          ),
        );
      },
    );
  }
}