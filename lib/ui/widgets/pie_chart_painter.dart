// import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
// import 'package:flutter/material.dart';

// class PieChartPainter extends CustomPainter {
//   final double healthPercent;
//   final double safetyPercent;
//   final double financePercent;

//   PieChartPainter({
//     required this.healthPercent,
//     required this.safetyPercent,
//     required this.financePercent,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;

//     final healthPaint = Paint()
//       ..color = AppTheme.healthColor
//       ..strokeWidth = 0;
//     final safetyPaint = Paint()
//       ..color = AppTheme.safetyColor
//       ..strokeWidth = 0;
//     final financePaint = Paint()
//       ..color = AppTheme.financeColor
//       ..strokeWidth = 0;

//     double startAngle = -3.14159 / 2;

//     // Health
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       (healthPercent / 100) * 6.28318,
//       true,
//       healthPaint,
//     );
//     startAngle += (healthPercent / 100) * 6.28318;

//     // Safety
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       (safetyPercent / 100) * 6.28318,
//       true,
//       safetyPaint,
//     );
//     startAngle += (safetyPercent / 100) * 6.28318;

//     // Finance
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       (financePercent / 100) * 6.28318,
//       true,
//       financePaint,
//     );
//   }

//   @override
//   bool shouldRepaint(PieChartPainter oldDelegate) => true;
// }

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

    final strokeWidth = 20.0; // thickness of donut ring
    final gapAngle = 0.28; // radians (~3 degrees) gap between segments

    final healthPaint = Paint()
      ..color = AppTheme.healthColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final safetyPaint = Paint()
      ..color = AppTheme.safetyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final financePaint = Paint()
      ..color = AppTheme.financeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -3.14159 / 2;

    // Health arc with gap
    final healthSweep = (healthPercent / 100) * 6.28318 - gapAngle;
    if (healthSweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        healthSweep,
        false,
        healthPaint,
      );
      startAngle += healthSweep + gapAngle;
    }

    // Safety arc with gap
    final safetySweep = (safetyPercent / 100) * 6.28318 - gapAngle;
    if (safetySweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        safetySweep,
        false,
        safetyPaint,
      );
      startAngle += safetySweep + gapAngle;
    }

    // Finance arc with gap
    final financeSweep = (financePercent / 100) * 6.28318 - gapAngle;
    if (financeSweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        financeSweep,
        false,
        financePaint,
      );
    }

    // Blank hole in the middle
    final holeRadius = radius - strokeWidth / 2;
    final holePaint = Paint()..color = Colors.transparent;
    final total = healthPercent + safetyPercent + financePercent;
    canvas.drawCircle(center, holeRadius, holePaint);

    String label;
    double value;

    if (total == 0) {
      label = 'No Record';
      value = 0;
    } else{
      final Map<String, double> values = {
        'Health': healthPercent,
        'Safety': safetyPercent,
        'Finance': financePercent,
      };
      final dominant = values.entries.reduce((a, b) => a.value > b.value ? a : b);

      label = dominant.key;
      value = dominant.value;
    }

    // Center text
    final textSpan = TextSpan(
      text: label == 'No Record'
          ? 'No Record'
          : '$label\n${value.toStringAsFixed(1)}%',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offset =
        center - Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) => true;
}
