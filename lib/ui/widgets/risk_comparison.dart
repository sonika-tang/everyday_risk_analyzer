import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RiskComparisonCard extends StatefulWidget {
  final String headLine;
  final Map<String, dynamic> comparison; // {lastWeek, thisWeek, comparison}

  const RiskComparisonCard({
    super.key,
    required this.headLine,
    required this.comparison,
  });

  @override
  State<RiskComparisonCard> createState() => _RiskComparisonCardState();
}

class _RiskComparisonCardState extends State<RiskComparisonCard> {
  bool isExpanded = false;

  Color _getColor() {
    return AppTheme.successColor;
  }

  @override
  Widget build(BuildContext context) {
    final comparison = widget.comparison['comparison'] as Map<String, String>;
    final thisWeek = widget.comparison['thisWeek'] as Map<String, int>;

    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getColor().withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getColor(),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.headLine,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: _getColor(),
                ),
              ],
            ),

            // Expanded details
            if (isExpanded) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Category comparison
              Text(
                "Category Comparison (Last vs This Week)",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              ...comparison.entries.map((entry) {
                final category = entry.key;
                final summary = entry.value;
                final count = thisWeek[category] ?? 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$category: $summary",
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (count / 10).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getColor(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
