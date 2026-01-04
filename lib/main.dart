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

  void _toggleTheme() {
    if (_profile == null) return;

    // Create a new instance with flipped theme
    final updated = UserProfile(
      id: _profile!.id,
      name: _profile!.name,
      email: _profile!.email,
      createdAt: _profile!.createdAt,
      isDarkMode: !_profile!.isDarkMode,
      // include any other fields your UserProfile has
    );

    setState(() {
      _profile = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile || _profile == null) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    // return MaterialApp(
    //   title: 'Risk Analysis',
    //   theme: _profile!.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
    //   home: SplashScreen(onThemeChange: _loadProfile),
    //   debugShowCheckedModeBanner: false,
    // );
    return MaterialApp(
      title: 'Risk Analysis',
      theme: AppTheme.lightTheme, 
      darkTheme: AppTheme.darkTheme, 
      themeMode: _profile!.isDarkMode ? ThemeMode.dark : ThemeMode.light, 
      home: SplashScreen(onThemeChange: _toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}
