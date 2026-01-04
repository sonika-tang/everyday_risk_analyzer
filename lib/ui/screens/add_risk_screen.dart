import 'package:everyday_risk_analyzer/data/mock_risks.dart';
import 'package:everyday_risk_analyzer/logic/serverity_logic.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:everyday_risk_analyzer/ui/widgets/category_selector.dart';
import 'package:everyday_risk_analyzer/ui/widgets/date_selector.dart';
import 'package:everyday_risk_analyzer/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';

class AddRiskDialog extends StatefulWidget {
  final VoidCallback onRiskAdded;

  const AddRiskDialog({super.key, required this.onRiskAdded});

  @override
  State<AddRiskDialog> createState() => _AddRiskDialogState();
}

class _AddRiskDialogState extends State<AddRiskDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = 'Health';
  String selectedReason = 'Stress';
  String selectedUrgency = 'Calm';
  String selectedControlLevel = 'Fully Avoidable';

  DateTime selectedDate = DateTime.now();
  bool isSubmitting = false;
  String? calculatedSeverity;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Risk',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title
              InputField(
                label: 'Risk Title *',
                controller: titleController,
                hintText: 'What risk did you take?',
                icon: Icons.warning,
                onChanged: (_) => _updateSeverity(),
              ),
              const SizedBox(height: 16),

              // Reason
              DropdownButtonFormField<String>(
                initialValue: selectedReason,
                items: ['Stress', 'Forgot', 'Financial', 'Careless']
                    .map((reason) => DropdownMenuItem(
                          value: reason,
                          child: Text(reason),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedReason = val!),
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
              const SizedBox(height: 16),

              // Urgency
              DropdownButtonFormField<String>(
                initialValue: selectedUrgency,
                items: ['Emergency', 'Rushed', 'Calm']
                    .map((urgency) => DropdownMenuItem(
                          value: urgency,
                          child: Text(urgency),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedUrgency = val!),
                decoration: const InputDecoration(labelText: 'Urgency'),
              ),
              const SizedBox(height: 16),

              // Control Level
              DropdownButtonFormField<String>(
                initialValue: selectedControlLevel,
                items: ['Fully Avoidable', 'Partially', 'Unavoidable']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedControlLevel = val!),
                decoration: const InputDecoration(labelText: 'Control Level'),
              ),
              const SizedBox(height: 16),

              // Description
              InputField(
                label: 'Description',
                controller: descriptionController,
                hintText: 'Describe what happened (optional)',
                maxLines: 3,
                onChanged: (_) => _updateSeverity(),
              ),
              const SizedBox(height: 16),

              // Category
              CategorySelector(
                selectedCategory: selectedCategory,
                onCategoryChanged: (cat) {
                  setState(() => selectedCategory = cat);
                  _updateSeverity();
                },
              ),
              const SizedBox(height: 16),

              // Severity Display
              if (calculatedSeverity != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(calculatedSeverity!).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getSeverityColor(calculatedSeverity!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getSeverityIcon(calculatedSeverity!),
                        color: _getSeverityColor(calculatedSeverity!),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Severity: $calculatedSeverity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getSeverityColor(calculatedSeverity!),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Date
              DateSelector(
                selectedDate: selectedDate,
                onDateChanged: (date) => setState(() => selectedDate = date),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : _addRisk,
                      icon: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add),
                      label: Text(isSubmitting ? 'Adding...' : 'Add Risk'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateSeverity() {
    setState(() {
      if (titleController.text.isNotEmpty) {
        final severityResult = SeverityCalculator.calculateSeverity(
          titleController.text,
          descriptionController.text,
          selectedCategory,
        );
        calculatedSeverity = severityResult.label;
      } else {
        calculatedSeverity = null;
      }
    });
  }

  Future<void> _addRisk() async {
    if (titleController.text.trim().isEmpty) {
      _showSnackBar('Please enter a risk title', isError: true);
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final severityResult = SeverityCalculator.calculateSeverity(
        titleController.text,
        descriptionController.text,
        selectedCategory,
      );

      final newRisk = RiskEntry(
        id: DateTime.now().toString(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory,
        severity: severityResult.label,
        date: selectedDate,
        createdAt: DateTime.now(),
        frequency: 1,
        controlLevel: selectedControlLevel,
        reason: selectedReason,
        urgency: selectedUrgency,
      );

      await StorageService.addRisk(newRisk); // add to mock list
      _showSnackBar('Risk added successfully!', isError: false);
      widget.onRiskAdded();
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: isError
            ? AppTheme.highRiskColor
            : AppTheme.successColor,
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    if (severity == 'High') return AppTheme.highRiskColor;
    if (severity == 'Medium') return AppTheme.mediumRiskColor;
    return AppTheme.lowRiskColor;
  }

  IconData _getSeverityIcon(String severity) {
    if (severity == 'High') return Icons.dangerous;
    if (severity == 'Medium') return Icons.warning;
    return Icons.info;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
