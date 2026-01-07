import 'package:flutter_test/flutter_test.dart';
import 'package:everyday_risk_analyzer/data/behavior_patterns.dart';

void main() {
  group('Behavior Patterns Tests', () {
    // Test Case 1: MEAL_SKIPPING Detection
    test('TC1: Should detect MEAL_SKIPPING pattern with multiple keywords', () {
      const testCases = [
        'skipped breakfast',
        'missed lunch',
        'no dinner',
        'forgot to eat',
        'hungry all day',
        'ate nothing',
        'no food today',
        'starving',
      ];

      final mealSkippingPattern = behaviorPatterns.firstWhere(
        (p) => p.code == 'MEAL_SKIPPING',
      );

      for (final keyword in testCases) {
        final isMatched = mealSkippingPattern.keywords
            .any((kw) => keyword.toLowerCase().contains(kw));
        expect(isMatched, true,
            reason: 'Keyword "$keyword" should match MEAL_SKIPPING pattern');
      }
    });

    // Test Case 2: SLEEP_DEPRIVATION Pattern
    test('TC2: Should detect SLEEP_DEPRIVATION pattern', () {
      const testCases = [
        'didn\'t sleep',
        'awake all night',
        'slept very late',
        'only 3 hours sleep',
        'tired today',
        'no rest',
        'insomnia',
      ];

      final sleepPattern = behaviorPatterns.firstWhere(
        (p) => p.code == 'SLEEP_DEPRIVATION',
      );

      for (final keyword in testCases) {
        final isMatched = sleepPattern.keywords
            .any((kw) => keyword.toLowerCase().contains(kw));
        expect(isMatched, true,
            reason: 'Keyword "$keyword" should match SLEEP_DEPRIVATION pattern');
      }
    });

    // Test Case 3: OVERSPENDING Pattern
    test('TC3: Should detect OVERSPENDING pattern', () {
      const testCases = [
        'overspent money',
        'too much shopping',
        'credit card debt',
        'missed loan payment',
        'broke this week',
        'spent all savings',
        'impulse buying',
      ];

      final spendingPattern = behaviorPatterns.firstWhere(
        (p) => p.code == 'OVERSPENDING',
      );

      for (final keyword in testCases) {
        final isMatched = spendingPattern.keywords
            .any((kw) => keyword.toLowerCase().contains(kw));
        expect(isMatched, true,
            reason: 'Keyword "$keyword" should match OVERSPENDING pattern');
      }
    });

    // Test Case 4: UNSAFE_BEHAVIOR Pattern
    test('TC4: Should detect UNSAFE_BEHAVIOR pattern', () {
      const testCases = [
        'driving without helmet',
        'no seatbelt',
        'using phone while driving',
        'speeding',
        'reckless driving',
        'jaywalking',
      ];

      final unsafePattern = behaviorPatterns.firstWhere(
        (p) => p.code == 'UNSAFE_BEHAVIOR',
      );

      for (final keyword in testCases) {
        final isMatched = unsafePattern.keywords
            .any((kw) => keyword.toLowerCase().contains(kw));
        expect(isMatched, true,
            reason: 'Keyword "$keyword" should match UNSAFE_BEHAVIOR pattern');
      }
    });

    // Test Case 5: MENTAL_STRESS Pattern
    test('TC5: Should detect MENTAL_STRESS pattern', () {
      const testCases = [
        'feeling stressed',
        'anxiety attack',
        'depressed mood',
        'panic today',
        'overwhelmed at work',
        'burnout',
        'too much pressure',
      ];

      final stressPattern = behaviorPatterns.firstWhere(
        (p) => p.code == 'MENTAL_STRESS',
      );

      for (final keyword in testCases) {
        final isMatched = stressPattern.keywords
            .any((kw) => keyword.toLowerCase().contains(kw));
        expect(isMatched, true,
            reason: 'Keyword "$keyword" should match MENTAL_STRESS pattern');
      }
    });
  });
}