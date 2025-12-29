import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  final List<RiskEntry> risks;
  const CalendarScreen({super.key, required this.risks});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
