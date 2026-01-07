import 'package:flutter_test/flutter_test.dart';
import 'package:everyday_risk_analyzer/logic/risk_logic.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';

void main() {
  group('RiskLogicEngine Tests', () {
    late List<RiskEntry> testRisks;

    setUp(() {
      // Create test data
      testRisks = [
        RiskEntry(
          id: '1',
          title: 'Skipped breakfast',
          description: 'Did not eat breakfast',
          category: 'Health',
          severity: 'Low',
          date: DateTime.now().subtract(Duration(days: 1)),
          createdAt: DateTime.now(),
          controlLevel: 'Fully Avoidable',
          reason: 'Forgot',
          urgency: 'Calm',
        ),
        RiskEntry(
          id: '2',
          title: 'Skipped breakfast',
          description: 'Did not eat breakfast again',
          category: 'Health',
          severity: 'Low',
          date: DateTime.now(),
          createdAt: DateTime.now(),
          controlLevel: 'Fully Avoidable',
          reason: 'Forgot',
          urgency: 'Calm',
        ),
        RiskEntry(
          id: '3',
          title: 'No seatbelt',
          description: 'Drove without seatbelt',
          category: 'Safety',
          severity: 'Medium',
          date: DateTime.now(),
          createdAt: DateTime.now(),
          controlLevel: 'Fully Avoidable',
          reason: 'Careless',
          urgency: 'Calm',
        ),
        RiskEntry(
          id: '4',
          title: 'Overspent money',
          description: 'Spent too much on shopping',
          category: 'Finance',
          severity: 'Low',
          date: DateTime.now(),
          createdAt: DateTime.now(),
          controlLevel: 'Fully Avoidable',
          reason: 'Impulse',
          urgency: 'Calm',
        ),
      ];
    });

    // Test Case 1: Risk Escalation Based on Repetition
    test('TC1: Risk should escalate to High with 5+ repetitions', () {
      final repeatedRisks = List.generate(5, (i) {
        return RiskEntry(
          id: '$i',
          title: 'skipped breakfast',
          description: 'Did not eat breakfast',
          category: 'Health',
          severity: 'Low',
          date: DateTime.now().subtract(Duration(days: i)),
          createdAt: DateTime.now(),
          controlLevel: 'Fully Avoidable',
          reason: 'Forgot',
          urgency: 'Calm',
        );
      });

      final severity =
          RiskLogicEngine.evaluateEscalatedSeverity(repeatedRisks[4], repeatedRisks);
      expect(severity, equals('High'));
    });

    // Test Case 2: Behavioral Pattern Detection
    test('TC2: Should detect MEAL_SKIPPING pattern', () {
      final risk = RiskEntry(
        id: '1',
        title: 'skipped breakfast today',
        description: 'Did not eat breakfast',
        category: 'Health',
        severity: 'Low',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        controlLevel: 'Fully Avoidable',
        reason: 'Forgot',
        urgency: 'Calm',
      );

      final pattern = RiskLogicEngine.detectBehavioralPatterns(risk);
      expect(pattern, equals('MEAL_SKIPPING'));
    });

    // Test Case 3: Overall Risk Score Calculation
    test('TC3: Should calculate risk score within valid range', () {
      final score = RiskLogicEngine.calculateRiskScore(testRisks);
      expect(score, greaterThanOrEqualTo(0));
      expect(score, lessThanOrEqualTo(100));
    });

    // Test Case 4: Weekly Frequency 
    test('TC4: Should count weekly frequencies correctly', () {
      final engine = RiskLogicEngine();
      final weeklyCount = engine.getWeeklyFrequency(testRisks[0], testRisks);
      
      expect(weeklyCount, greaterThan(0));
    });

    // Test Case 5: Month Filtering
    test('TC5: Should filter risks by month correctly', () {
      final now = DateTime.now();
      final filtered = RiskLogicEngine.filterByMonth(testRisks, now.month, now.year);
      
      expect(filtered.isNotEmpty, true);
      for (var risk in filtered) {
        expect(risk.date.month, equals(now.month));
        expect(risk.date.year, equals(now.year));
      }
    });

    // Test Case 6: Weekly Summary Calculation
    test('TC6: Should calculate weekly summary correctly', () {
      final weekStart = DateTime.now().subtract(Duration(days: 7));
      final summary = RiskLogicEngine.calculateWeeklySummary(testRisks, weekStart);
      
      expect(summary.containsKey('Health'), true);
      expect(summary.containsKey('Safety'), true);
      expect(summary.containsKey('Finance'), true);
    });

    // Test Case 7: Get Recent Risks
    test('TC7: Should get risks from last 7 days', () {
      final recent = RiskLogicEngine.getRecentRisks(testRisks, days: 7);
      
      for (var risk in recent) {
        final daysAgo = DateTime.now().difference(risk.date).inDays;
        expect(daysAgo, lessThanOrEqualTo(7));
      }
    });

    // Test Case 8: Get Risks For Specific Date
    test('TC8: Should get risks for specific date', () {
      final today = DateTime.now();
      final todayRisks = RiskLogicEngine.getRisksForDate(testRisks, today);
      
      for (var risk in todayRisks) {
        expect(risk.date.day, equals(today.day));
        expect(risk.date.month, equals(today.month));
      }
    });

    // Test Case 9: Get Dates With Risks
    test('TC9: Should return all unique dates with risks', () {
      final dates = RiskLogicEngine.getDatesWithRisks(testRisks);
      
      expect(dates.isNotEmpty, true);
      expect(dates.length, lessThanOrEqualTo(testRisks.length));
    });

    // Test Case 10: Unclassified Pattern Detection
    test('TC10: Should return UNCLASSIFIED for unknown patterns', () {
      final unknownRisk = RiskEntry(
        id: '99',
        title: 'Unknown Risk Type',
        description: 'Some random behavior',
        category: 'Health',
        severity: 'Low',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        controlLevel: 'Partially',
        reason: 'Unknown',
        urgency: 'Calm',
      );

      final pattern = RiskLogicEngine.detectBehavioralPatterns(unknownRisk);
      expect(pattern, equals('UNCLASSIFIED'));
    });

    // Test Case 11: Monthly Frequency Detection
    test('TC11: Should count monthly frequencies correctly', () {
      final engine = RiskLogicEngine();
      final monthlyCount = engine.getMonthlyFrequency(testRisks[0], testRisks);
      
      expect(monthlyCount, greaterThan(0));
    });

    // Test Case 12: Empty Risk List Handling
    test('TC12: Should handle empty risk list gracefully', () {
      final emptyList = <RiskEntry>[];
      
      final score = RiskLogicEngine.calculateRiskScore(emptyList);
      final overall = RiskLogicEngine.calculateOverallRisk(emptyList);
      final summary = RiskLogicEngine.calculateWeeklySummary(emptyList, DateTime.now());
      
      expect(score, equals(0));
      expect(overall, equals('Low'));
      expect(summary['Health'], equals(0));
    });
  });
}