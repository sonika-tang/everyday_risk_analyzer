import 'package:everyday_risk_analyzer/ui/screens/home_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onThemeChange;

  const SplashScreen({super.key, required this.onThemeChange});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
with SingleTickerProviderStateMixin { // Keep the refresh rate of the app (not skip any frame) - keeps them in sync with screen refresh
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this, //uses the state object as ticker provider
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(     //Tween from 0 (transparent) → 1 (opaque)
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn), //Uses Curves.easeIn for smooth start
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(  //Tween from 0.5 (half size) → 1 (full size)
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut), // Uses Curves.elasticOut for a springy “pop-in” effect
    );

    _animationController.forward(); //Starts the animation immediately when splash screen loads

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) { //ensures widget is still in the tree before navigating
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomeScreen(onThemeChange: widget.onThemeChange),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Icon(Icons.shield, size: 100, color: AppTheme.accentColor),
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text('Risk Analysis',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            SizedBox(height: 10),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text('Monitor & Manage Your Risks',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}