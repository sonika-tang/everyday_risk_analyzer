import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SeveritySelector extends StatelessWidget {
  final String selectedSeverity;
  final Function(String) onSeverityChanged;

  const SeveritySelector({super.key, 
    required this.selectedSeverity,
    required this.onSeverityChanged,
  });

  Color _getSeverityColor(String sev) {
    if (sev == 'High') return AppTheme.highRiskColor;
    if (sev == 'Medium') return AppTheme.mediumRiskColor;
    return AppTheme.lowRiskColor;
  }

  IconData _getSeverityIcon(String sev) {
    if (sev == 'High') return Icons.dangerous;
    if (sev == 'Medium') return Icons.warning;
    return Icons.info;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Severity *',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: ['Low', 'Medium', 'High'].map((sev) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onSeverityChanged(sev),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selectedSeverity == sev
                        ? _getSeverityColor(sev)
                        : (Theme.of(context).brightness == Brightness.dark
                            ? Color(0xFF1a2332)
                            : Color(0xFFe3f2fd)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedSeverity == sev
                          ? _getSeverityColor(sev)
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: selectedSeverity == sev
                        ? [
                            BoxShadow(
                              color: _getSeverityColor(sev).withValues(alpha: .3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getSeverityIcon(sev),
                        color: selectedSeverity == sev
                            ? Colors.white
                            : _getSeverityColor(sev),
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        sev,
                        style: TextStyle(
                          color: selectedSeverity == sev
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}