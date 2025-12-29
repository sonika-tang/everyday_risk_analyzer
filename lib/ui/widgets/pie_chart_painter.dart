import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  final double healthPercent;
  final double safetyPercent;
  final double financePercent;

  PieChartPainter({
    required this.healthPercent,
    required this.safetyPercent,
    required this.financePercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final healthPaint = Paint()
      ..color = AppTheme.healthColor
      ..strokeWidth = 0;
    final safetyPaint = Paint()
      ..color = AppTheme.safetyColor
      ..strokeWidth = 0;
    final financePaint = Paint()
      ..color = AppTheme.financeColor
      ..strokeWidth = 0;

    double startAngle = -3.14159 / 2;

    // Health
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      (healthPercent / 100) * 6.28318,
      true,
      healthPaint,
    );
    startAngle += (healthPercent / 100) * 6.28318;

    // Safety
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      (safetyPercent / 100) * 6.28318,
      true,
      safetyPaint,
    );
    startAngle += (safetyPercent / 100) * 6.28318;

    // Finance
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      (financePercent / 100) * 6.28318,
      true,
      financePaint,
    );
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) => true;
}