import 'package:flutter_test/flutter_test.dart';
import 'package:everyday_risk_analyzer/logic/severity_logic.dart';

void main() {
  group('SeverityCalculator Tests', () {
    // Test Case 1: High Severity Calculation
    test('TC1: Should calculate High severity correctly', () {
      final result = SeverityCalculator.calculateSeverity(
        'Reckless Driving',
        'Drove at high speed without care on the high way at night',
        'Safety',
        controlLevel: 'Fully Avoidable',
        urgency: 'Emergency',
        reason: 'Careless',
      );

      expect(result.label, equals('High'));
      expect(result.weight, equals(15));
    });

    // Test Case 2: Medium Severity Calculation
    test('TC2: Should calculate Medium severity correctly', () {
      final result = SeverityCalculator.calculateSeverity(
        'Overspending',
        'Spent more than budget this week',
        'Finance',
        controlLevel: 'Partially',
        urgency: 'Emergency',
        reason: 'Financial',
      );

      expect(result.label, equals('Medium'));
      expect(result.weight, equals(8));
    });

    // Test Case 3: Low Severity Calculation
    test('TC3: Should calculate Low severity correctly', () {
      final result = SeverityCalculator.calculateSeverity(
        'Minor Delay',
        'Arrived 5 minutes late',
        'Health',
        controlLevel: 'Unavoidable',
        urgency: 'Calm',
        reason: 'Traffic',
      );

      expect(result.label, equals('Low'));
      expect(result.weight, equals(3));
    });

    // Test Case 4: Empty Description Impact
    test('TC4: Should show longer description has higher impact', () {
      final shortDesc = SeverityCalculator.calculateSeverity(
        'Skipped Meal',
        '',
        'Health',
        controlLevel: 'Fully Avoidable',
        urgency: 'Calm',
        reason: 'Forgot',
      );

      final longDesc = SeverityCalculator.calculateSeverity(
        'Skipped Meal',
        'I was too busy at work and forgot to eat lunch even though I had food available in the office',
        'Health',
        controlLevel: 'Fully Avoidable',
        urgency: 'Calm',
        reason: 'Forgot',
      );

      expect(longDesc.weight, greaterThan(shortDesc.weight));
    });
  });
}
