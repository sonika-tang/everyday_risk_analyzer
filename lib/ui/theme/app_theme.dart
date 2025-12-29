import 'package:flutter/material.dart';

class AppTheme {
  // Check the theme color again too (I put dark as primary color) if you don't want it you can change
  static const Color primaryColor = Color(0xFF1e3a5f);
  static const Color accentColor = Color(0xFF00d4ff);
  static const Color highRiskColor = Color(0xFFef4444);
  static const Color mediumRiskColor = Color(0xFFfbbf24);
  static const Color lowRiskColor = Color(0xFF3b82f6);
  static const Color healthColor = Color(0xFF10b981);
  static const Color financeColor = Color(0xFFf59e0b);
  static const Color safetyColor = Color(0xFFef4444);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Color(0xFF0f1419),
    appBarTheme: AppBarTheme(backgroundColor: primaryColor, elevation: 0),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[300]),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF0066cc),
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    appBarTheme: AppBarTheme(backgroundColor: Color(0xFF0066cc), elevation: 0),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[600]),
    ),
  );
}
