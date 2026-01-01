import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final int maxLines;
  final Function(String)? onChanged;

  const InputField({super.key, 
    required this.label,
    required this.controller,
    required this.hintText,
    this.icon,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: hintText,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.accentColor, width: 2),
            ),
            prefixIcon: icon != null ? Icon(icon, color: AppTheme.accentColor) : null,
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Color(0xFF1a2332).withValues(alpha: .5)
                : Colors.white,
          ),
        ),
      ],
    );
  }
}