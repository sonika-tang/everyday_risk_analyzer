import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategorySelector({super.key, 
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  Color _getCategoryColor(String cat) {
    if (cat == 'Health') return AppTheme.healthColor;
    if (cat == 'Safety') return AppTheme.safetyColor;
    return AppTheme.financeColor;
  }

  IconData _getCategoryIcon(String cat) {
    if (cat == 'Health') return Icons.favorite;
    if (cat == 'Safety') return Icons.security;
    return Icons.attach_money;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 12),
        Row(
          children: ['Health', 'Safety', 'Finance'].map((cat) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onCategoryChanged(cat),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selectedCategory == cat
                        ? _getCategoryColor(cat)
                        : (Theme.of(context).brightness == Brightness.dark
                            ? Color(0xFF1a2332)
                            : Color(0xFFe3f2fd)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedCategory == cat ? _getCategoryColor(cat) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(cat),
                        color: selectedCategory == cat ? Colors.white : _getCategoryColor(cat),
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        cat,
                        style: TextStyle(
                          color: selectedCategory == cat ? Colors.white : Colors.grey,
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