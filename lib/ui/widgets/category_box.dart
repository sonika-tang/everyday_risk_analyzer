import 'package:everyday_risk_analyzer/logic/risk_logic.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/screens/risk_detail_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:everyday_risk_analyzer/ui/widgets/risk_card.dart';
import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final String title;
  final Map<String, int> data;
  final Color color;
  final VoidCallback onRefresh;

  final List<RiskEntry> risks;

  const CategoryBox({
    super.key,
    required this.title,
    required this.data,
    required this.color,
    required this.risks,
    required this.onRefresh
  });

  void _showMonthCategoryRisks(BuildContext context) {
    final now = DateTime.now();
    final categoryRisks = risks.where((risk) =>
      risk.category == title &&
      risk.date.year == now.year &&
      risk.date.month == now.month
    ).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title Risks',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            if (categoryRisks.isEmpty)
              const Center(
                child: Text(
                  'No risks recorded for this category',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: categoryRisks.map((risk) {
                    final computedSeverity =
                        RiskLogicEngine.evaluateEscalatedSeverity(risk, risks);

                    final weeklyCount =
                        RiskLogicEngine().getWeeklyFrequency(risk, risks);

                    final monthlyCount =
                        RiskLogicEngine().getMonthlyFrequency(risk, risks);

                    return RiskCard(
                      risk: risk,
                      severity: computedSeverity,       
                      weeklyFrequency: weeklyCount,     
                      monthlyFrequency: monthlyCount,     
                      showMonthlyFrequency: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            final severity = RiskLogicEngine.evaluateEscalatedSeverity(risk, risks);
                            final weekly = RiskLogicEngine().getWeeklyFrequency(risk, risks);
                            final monthly = RiskLogicEngine().getMonthlyFrequency(risk, risks);
                            return RiskDetailScreen(
                              severity: severity,
                              weeklyFrequency: weekly,
                              monthlyFrequency: monthly,
                              risk: risk,
                              onRiskDeleted: onRefresh,
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

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
              GestureDetector(
                onTap: () {
                  _showMonthCategoryRisks(context);
                },
                child: Text(
                  'Details >>',
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _RiskCountWidget(
                count: '${data['high'] ?? 0}',
                label: 'High',
                color: AppTheme.highRiskColor,
              ),
              _RiskCountWidget(
                count: '${data['medium'] ?? 0}',
                label: 'Medium',
                color: AppTheme.mediumRiskColor,
              ),
              _RiskCountWidget(
                count: '${data['low'] ?? 0}',
                label: 'Low',
                color: AppTheme.lowRiskColor,
              ),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
