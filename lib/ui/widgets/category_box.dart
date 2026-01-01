import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final String title;
  final Map<String, int> data;
  final Color color;

  const CategoryBox({super.key, 
    required this.title,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF1a2332)
            : Color(0xFFe3f2fd),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              Text('Details',
                  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _RiskCountWidget(
                  count: '${data['high'] ?? 0}', label: 'High', color: AppTheme.highRiskColor),
              _RiskCountWidget(
                  count: '${data['medium'] ?? 0}',
                  label: 'Medium',
                  color: AppTheme.mediumRiskColor),
              _RiskCountWidget(count: '${data['low'] ?? 0}', label: 'Low', color: AppTheme.lowRiskColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskCountWidget extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _RiskCountWidget({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}