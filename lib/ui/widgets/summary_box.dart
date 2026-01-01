import 'package:flutter/material.dart';

class SummaryBox extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const SummaryBox({
    super.key,
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
