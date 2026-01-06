import 'package:everyday_risk_analyzer/data/risk_storage_service.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:everyday_risk_analyzer/ui/widgets/info_tile.dart';
import 'package:flutter/material.dart';

class RiskDetailScreen extends StatelessWidget {
  final RiskEntry risk;
  final VoidCallback onRiskDeleted;

  const RiskDetailScreen({super.key, 
    required this.risk,
    required this.onRiskDeleted,
  });

  Color _getSeverityColor() {
    if (risk.severity == 'High') return AppTheme.highRiskColor;
    if (risk.severity == 'Medium') return AppTheme.mediumRiskColor;
    return AppTheme.lowRiskColor;
  }

  Color _getCategoryColor() {
    if (risk.category == 'Health') return AppTheme.healthColor;
    if (risk.category == 'Safety') return AppTheme.safetyColor;
    return AppTheme.financeColor;
  }

  IconData _getSeverityIcon() {
    if (risk.severity == 'High') return Icons.dangerous;
    if (risk.severity == 'Medium') return Icons.warning;
    return Icons.info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Risk Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: AppTheme.highRiskColor),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF1a2332)
                    : Color(0xFFe3f2fd),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getSeverityColor(), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with Severity Icon
                  Row(
                    children: [
                      Icon(_getSeverityIcon(), color: _getSeverityColor(), size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(risk.title,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 6),
                            Text(risk.category,
                                style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Badges
                  Row(
                    children: [
                      Chip(
                        label: Text(risk.severity, style: TextStyle(color: Colors.white)),
                        backgroundColor: _getSeverityColor(),
                      ),
                      SizedBox(width: 8),
                      Chip(
                        label: Text(risk.category, style: TextStyle(color: Colors.white)),
                        backgroundColor: _getCategoryColor(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Description
                  Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 8),
                  Text(
                    risk.description.isEmpty ? 'No description provided' : risk.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Info Section
            Text('Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            InfoTile('Date', '${risk.date.day}/${risk.date.month}/${risk.date.year}'),
            InfoTile('Recorded', '${risk.createdAt.day}/${risk.createdAt.month}/${risk.createdAt.year}'),
            InfoTile('Reason', risk.reason),
            InfoTile('Urgency', risk.urgency),
            InfoTile('Control Level', risk.controlLevel),
            InfoTile('Frequency', '${risk.frequency} time${risk.frequency > 1 ? 's' : ''}'),
            InfoTile('Severity', risk.severity),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Risk'),
        content: Text('Are you sure you want to delete this risk?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await RiskStorageService.deleteRisk(risk.id);
              if (!context.mounted) return; //check to prevent updating or navigating from a widget that’s no longer in the widget tree
              Navigator.pop(context);
              Navigator.pop(context);
              onRiskDeleted();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.highRiskColor),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}