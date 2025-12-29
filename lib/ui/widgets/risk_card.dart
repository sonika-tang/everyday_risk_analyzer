import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RiskCard extends StatelessWidget {
  final RiskEntry risk;
  final VoidCallback? onTap;

  const RiskCard({super.key, required this.risk, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color severityColor = risk.severity == 'High'
        ? AppTheme.highRiskColor
        : risk.severity == 'Medium'
        ? AppTheme.mediumRiskColor
        : AppTheme.lowRiskColor;

    IconData icon = risk.category == 'Health'
        ? Icons.favorite
        : risk.category == 'Safety'
        ? Icons.security
        : Icons.attach_money;

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
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF0f1419)
                    : Colors.white,
              ),
              child: Icon(icon, color: severityColor, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    risk.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    risk.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
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
                    color: severityColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    risk.severity,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatDate(risk.date),
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
}
