import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  final List<String> anomalies;

  const AlertBox({super.key, required this.anomalies});

  @override
  Widget build(BuildContext context) {
    if (anomalies.isEmpty) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.highRiskColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.highRiskColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('⚠️ Alerts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 8),
          ...anomalies
              .map((anomaly) => Text(anomaly,
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey[300])))
              ,
        ],
      ),
    );
  }
}