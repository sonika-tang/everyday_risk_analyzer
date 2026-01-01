import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RecommendationCard extends StatefulWidget {
  final String recommendation;
  final List<String> anomalies;
  final Map<String, dynamic> prediction;

  const RecommendationCard({super.key, 
    required this.recommendation,
    required this.anomalies,
    required this.prediction,
  });

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  bool isExpanded = false;

  Color _getRecommendationColor() {
    if (widget.recommendation.startsWith('🚨') ||
        widget.recommendation.startsWith('🔴')) {
      return AppTheme.highRiskColor;
    } else if (widget.recommendation.startsWith('🟠')) {
      return AppTheme.highRiskColor;
    } else if (widget.recommendation.startsWith('🟡')) {
      return AppTheme.mediumRiskColor;
    } else {
      return AppTheme.successColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getRecommendationColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getRecommendationColor(),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.recommendation,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: _getRecommendationColor(),
                ),
              ],
            ),
            if (isExpanded) ...[
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 12),
              Text(
                'Prediction: ${widget.prediction['prediction']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value:
                    (widget.prediction['lastWeekCount'] / 25).clamp(0.0, 1.0),
                backgroundColor: Colors.grey[700],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getRecommendationColor(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}