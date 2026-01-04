import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RiskCard extends StatelessWidget {
  final RiskEntry risk;
  final bool showWeeklyFrequency;
  final bool showMonthlyFrequency;
  final VoidCallback? onTap;

  const RiskCard({
    super.key,
    required this.risk,
    this.showMonthlyFrequency = false,
    this.showWeeklyFrequency = false,
    this.onTap,
  });

  Color _getSeverityColor() {
    if (risk.severity == 'High') return AppTheme.highRiskColor;
    if (risk.severity == 'Medium') return AppTheme.mediumRiskColor;
    return AppTheme.lowRiskColor;
  }

  IconData _getCategoryIcon() {
    if (risk.category == 'Health') return Icons.favorite;
    if (risk.category == 'Safety') return Icons.security;
    return Icons.attach_money;
  }

  String _formatDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    String frequencyText = risk.category; 
    if (showWeeklyFrequency) 
    { 
      frequencyText += ' • W:${risk.frequency}'; 
    } 
    if (showMonthlyFrequency) { 
      frequencyText += ' • M:${risk.frequency}'; 
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF1a2332)
              : Color(0xFFe3f2fd),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _getSeverityColor().withValues(alpha: .3)),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getSeverityColor().withValues(alpha: .2),
              ),
              child: Icon(
                _getCategoryIcon(),
                color: _getSeverityColor(),
                size: 22,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    risk.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    frequencyText,
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    risk.severity,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatDate(risk.date),
                  style: TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
