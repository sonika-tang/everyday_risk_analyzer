import 'package:everyday_risk_analyzer/data/risk_analyzer.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/screens/risk_detail_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:everyday_risk_analyzer/ui/widgets/risk_card.dart';
import 'package:flutter/material.dart';

class WeeklySummaryScreen extends StatelessWidget {
  final List<RiskEntry> risks;
  final VoidCallback onRefresh;

  const WeeklySummaryScreen({super.key, required this.risks, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    var summary = RiskLogicEngine.calculateWeeklySummary(risks);
    var recent = RiskLogicEngine.getRecentRisks(risks, days: 7);
    String recommendation = RiskLogicEngine.getRiskRecommendation(risks);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 20),
          Text('Risk Analysis', style: Theme.of(context).textTheme.headlineLarge),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF1a2332)
                  : Color(0xFFe3f2fd),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text('Weekly Summary', style: Theme.of(context).textTheme.bodyLarge),
                Text('Dec 8 - Dec 14, 2025',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600])),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryBox('${summary['health']}', 'Health', AppTheme.healthColor),
                    _buildSummaryBox('${summary['finance']}', 'Finance', AppTheme.financeColor),
                    _buildSummaryBox('${summary['safety']}', 'Safety', AppTheme.safetyColor),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF1a2332)
                  : Color(0xFFfff3e0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.mediumRiskColor, width: 1),
            ),
            child: Text(
              recommendation,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Risks', style: Theme.of(context).textTheme.headlineMedium),
              Icon(Icons.filter_list, color: Colors.grey),
            ],
          ),
          SizedBox(height: 16),
          if (recent.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No risks recorded yet. Great job!',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            )
          else
            ...recent.map((risk) => RiskCard(risk: risk, onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => RiskDetailScreen(risk: risk), // Still fixing
                  ));
                })),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String count, String label, Color color) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}