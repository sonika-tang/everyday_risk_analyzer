import 'package:everyday_risk_analyzer/ui/screens/home_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onThemeChange;

  const SplashScreen({super.key, required this.onThemeChange});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(onThemeChange: widget.onThemeChange)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, size: 80, color: AppTheme.accentColor),
            SizedBox(height: 20),
            Text('Risk Analysis', style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            Text('Monitor & Manage Your Risks', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
