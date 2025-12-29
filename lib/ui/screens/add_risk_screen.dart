import 'package:everyday_risk_analyzer/data/mock_risks.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

// This screen is just a mock up first (I don't know what to put)
class AddRiskScreen extends StatefulWidget {
  final VoidCallback onRiskAdded;

  const AddRiskScreen({super.key, required this.onRiskAdded});

  @override
  State<AddRiskScreen> createState() => _AddRiskScreenState();
}

class _AddRiskScreenState extends State<AddRiskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedCategory = 'Health';
  String selectedSeverity = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Risk')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 20),
          Text(
            'Record a Risk',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 20),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Risk Title',
              hintText: 'e.g., Skipped breakfast',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Describe the risk details',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('Category', style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          Row(
            children: ['Health', 'Safety', 'Finance'].map((cat) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedCategory == cat
                          ? _getCategoryColor(cat)
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Color(0xFF1a2332)
                                : Color(0xFFe3f2fd)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      cat,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedCategory == cat
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text('Severity', style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          Row(
            children: ['Low', 'Medium', 'High'].map((sev) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedSeverity = sev),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedSeverity == sev
                          ? _getSeverityColor(sev)
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Color(0xFF1a2332)
                                : Color(0xFFe3f2fd)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sev,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedSeverity == sev
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _addRisk(),
            icon: Icon(Icons.add),
            label: Text('Add Risk'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  // Add risk
  void _addRisk() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a risk title')));
      return;
    }

    final newRisk = RiskEntry(
      id: DateTime.now().toString(), // Can change to UUID instead
      title: titleController.text,
      description: descriptionController.text,
      category: selectedCategory,
      severity: selectedSeverity,
      date: DateTime.now(),
    );

    StorageService.addRisk(newRisk).then((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Risk added successfully!')));
      widget.onRiskAdded();
      Navigator.pop(context);
    });
  }

  Color _getCategoryColor(String category) {
    if (category == 'Health') return AppTheme.healthColor;
    if (category == 'Safety') return AppTheme.safetyColor;
    return AppTheme.financeColor;
  }

  Color _getSeverityColor(String severity) {
    if (severity == 'High') return AppTheme.highRiskColor;
    if (severity == 'Medium') return AppTheme.mediumRiskColor;
    return AppTheme.lowRiskColor;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
