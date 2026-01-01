import 'package:everyday_risk_analyzer/logic/risk_logic.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/screens/add_risk_screen.dart';
import 'package:everyday_risk_analyzer/ui/screens/risk_detail_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:everyday_risk_analyzer/ui/widgets/alert_box.dart';
import 'package:everyday_risk_analyzer/ui/widgets/recommendation_card.dart';
import 'package:everyday_risk_analyzer/ui/widgets/risk_card.dart';
import 'package:everyday_risk_analyzer/ui/widgets/summary_box.dart';
import 'package:flutter/material.dart';

class WeeklySummaryScreen extends StatelessWidget {
  final List<RiskEntry> risks;
  final VoidCallback onRefresh;

  const WeeklySummaryScreen({
    super.key,
    required this.risks,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    var summary = RiskLogicEngine.calculateWeeklySummary(risks);
    var recent = RiskLogicEngine.getRecentRisks(risks, days: 7);
    var patterns = RiskLogicEngine.detectBehavioralPatterns(risks);
    var prediction = RiskLogicEngine.predictNextWeekRisk(risks);
    String recommendation = RiskLogicEngine.getRecommendation(risks);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 20),
          Text(
            'Risk Analysis',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 20),
          // Weekly Summary Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF1a2332)
                  : Color(0xFFe3f2fd),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentColor.withValues(alpha: .3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Weekly Summary',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Dec 8 - Dec 14, 2025', // Update this later (make it dynamic)
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SummaryBox(
                      count: '${summary['health'] ?? 0}',
                      label: 'Health',
                      color: AppTheme.healthColor,
                    ),
                    SummaryBox(
                      count: '${summary['finance'] ?? 0}',
                      label: 'Finance',
                      color: AppTheme.financeColor,
                    ),
                    SummaryBox(
                      count: '${summary['safety'] ?? 0}',
                      label: 'Safety',
                      color: AppTheme.safetyColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Recommendation Card
          RecommendationCard(
            recommendation: recommendation,
            anomalies: patterns['anomalies'] as List<String>,
            prediction: prediction,
          ),
          SizedBox(height: 16),
          // Alert Box
          AlertBox(anomalies: patterns['anomalies'] as List<String>),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Risks (${recent.length})',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // Icon(Icons.filter_list, color: Colors.grey),
            ],
          ),
          SizedBox(height: 16),
          if (recent.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 50,
                      color: AppTheme.successColor,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No risks recorded!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Great job maintaining a healthy lifestyle.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            ...recent.map(
              (risk) => RiskCard(
                risk: risk,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RiskDetailScreen(risk: risk, onRiskDeleted: () {}),
                  ),
                ),
              ),
            ),
          FloatingActionButton(
            onPressed: AddRiskDialog(onRiskAdded: () => {}, show: () {}).show, // Still fixing
            shape: CircleBorder(side: BorderSide(width: 2)),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
