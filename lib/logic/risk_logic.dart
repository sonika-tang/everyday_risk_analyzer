import 'package:everyday_risk_analyzer/logic/severity_logic.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/data/behavior_patterns.dart';

class RiskLogicEngine {
  // Filter by month
  static List<RiskEntry> filterByMonth(
    List<RiskEntry> risks,
    int month,
    int year,
  ) {
    return risks
        .where((r) => r.date.year == year && r.date.month == month)
        .toList();
  }

  // Algorithm 1: Risk Severity Escalation based on repetition patterns
  static String evaluateEscalatedSeverity(
    RiskEntry risk,
    List<RiskEntry> allRisks,
  ) {
    // Detect behavior code from title/description
    String combined = ('${risk.title} ${risk.description}').toLowerCase();
    String behaviorCode = 'UNCLASSIFIED';
    for (final pattern in behaviorPatterns) {
      if (pattern.keywords.any((kw) => combined.contains(kw))) {
        behaviorCode = pattern.code;
        break;
      }
    }

    // Count similar behaviors instead of exact titles
    int similarCount = allRisks.where((r) {
      String text = ('${r.title} ${r.description}').toLowerCase();
      return behaviorPatterns.any(
        (pattern) =>
            pattern.code == behaviorCode &&
            pattern.keywords.any((kw) => text.contains(kw)),
      );
    }).length;

    final baseSeverity = SeverityCalculator.calculateSeverity(
      risk.title,
      risk.description,
      risk.category,
      controlLevel: risk.controlLevel,
      urgency: risk.urgency,
      reason: risk.reason,
    ).label;

    if (similarCount >= 5) return 'High';
    if (similarCount >= 3) {
      if (baseSeverity == 'High') return 'High';
      if (baseSeverity == 'Medium') return 'High';
      return 'Medium';
    }

    // Time-based escalation
    DateTime now = DateTime.now();
    if (now.difference(risk.date).inHours <= 48 && baseSeverity == 'Medium') {
      return 'High';
    }

    return baseSeverity;
  }

  // Algorithm 2: Behavioral pattern recognition - detect clusters and anomalies
  static String detectBehavioralPatterns(RiskEntry risk) {
    String combined = ('${risk.title} ${risk.description}').toLowerCase();

    for (final pattern in behaviorPatterns) {
      if (pattern.keywords.any((kw) => combined.contains(kw))) {
        return pattern.code;
      }
    }

    return 'UNCLASSIFIED';
  }

  // Algorithm 3: Calculate overall risk score (0-100)
  static double calculateRiskScore(List<RiskEntry> risks) {
    if (risks.isEmpty) return 0;

    double totalScore = 0;
    for (var risk in risks) {
      final severity = SeverityCalculator.calculateSeverity(
        risk.title,
        risk.description,
        risk.category,
        controlLevel: risk.controlLevel,
        urgency: risk.urgency,
        reason: risk.reason,
      );
      totalScore += severity.weight;
    }

    return (totalScore / risks.length).clamp(0, 100);
  }

  // Algorithm 4: Compare last week vs this week risk frequencies
  static Map<String, dynamic> compareCategoryFrequencies(
    List<RiskEntry> risks,
  ) {
    DateTime now = DateTime.now();

    //Define week boundaries 
    DateTime thisWeekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1)); 
    DateTime thisWeekEnd = thisWeekStart.add(Duration(days: 6)); 

    DateTime lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    DateTime lastWeekEnd = thisWeekStart.subtract(const Duration(days: 1));

    // Separate risks 
    DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    List<RiskEntry> thisWeekRisks = risks
        .where((r) =>
            !dateOnly(r.date).isBefore(thisWeekStart) &&
            !dateOnly(r.date).isAfter(thisWeekEnd))
        .toList();

    List<RiskEntry> lastWeekRisks = risks
        .where((r) =>
            !dateOnly(r.date).isBefore(lastWeekStart) &&
            !dateOnly(r.date).isAfter(lastWeekEnd))
        .toList();
    // Count by category 
    Map<String, int> thisWeekCounts = {
      'Health': thisWeekRisks.where((r) => r.category == 'Health').length,
      'Safety': thisWeekRisks.where((r) => r.category == 'Safety').length,
      'Finance': thisWeekRisks.where((r) => r.category == 'Finance').length,
    };

    Map<String, int> lastWeekCounts = {
      'Health': lastWeekRisks.where((r) => r.category == 'Health').length,
      'Safety': lastWeekRisks.where((r) => r.category == 'Safety').length,
      'Finance': lastWeekRisks.where((r) => r.category == 'Finance').length,
    };

    // Build comparison 
    Map<String, String> comparison = {};
    for (var category in ['Health', 'Safety', 'Finance']) {
      int last = lastWeekCounts[category] ?? 0;
      int current = thisWeekCounts[category] ?? 0;
      int diff = current - last;

      if (diff > 0) {
        comparison[category] = '↑ Increased by $diff (from $last to $current)';
      } else if (diff < 0) {
        comparison[category] =
            '↓ Decreased by ${diff.abs()} (from $last to $current)';
      } else {
        comparison[category] = '→ No change ($current)';
      }
    }

    return {
      'lastWeek': lastWeekCounts,
      'thisWeek': thisWeekCounts,
      'comparison': comparison,
    };
  }

  // Weekly summary
  static Map<String, int> calculateWeeklySummary(
    List<RiskEntry> risks,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(Duration(days: 6));

    int health = 0;
    int finance = 0;
    int safety = 0;

    for (var risk in risks) {
      if (!risk.date.isBefore(weekStart) && !risk.date.isAfter(weekEnd)) {
        if (risk.category == 'Health') health++;
        if (risk.category == 'Finance') finance++;
        if (risk.category == 'Safety') safety++;
      }
    }

    return {'Health': health, 'Finance': finance, 'Safety': safety};
  }

  // Calculate overall risks base on the score
  static String calculateOverallRisk(List<RiskEntry> risks) {
    double score = calculateRiskScore(risks);
    if (score >= 70) return 'High';
    if (score >= 35) return 'Medium';
    return 'Low';
  }

  // Category Summary
  static Map<String, int> calculateCategorySummary(
    List<RiskEntry> risks,
    String category,
  ) {
    List<RiskEntry> catRisks = risks
        .where((r) => r.category == category)
        .toList();

    return {
      'high': catRisks
          .where(
            (r) =>
                SeverityCalculator.calculateSeverity(
                  r.title,
                  r.description,
                  r.category,
                  controlLevel: r.controlLevel,
                  urgency: r.urgency,
                  reason: r.reason,
                ).label ==
                'High',
          )
          .length,
      'medium': catRisks
          .where(
            (r) =>
                SeverityCalculator.calculateSeverity(
                  r.title,
                  r.description,
                  r.category,
                  controlLevel: r.controlLevel,
                  urgency: r.urgency,
                  reason: r.reason,
                ).label ==
                'Medium',
          )
          .length,
      'low': catRisks
          .where(
            (r) =>
                SeverityCalculator.calculateSeverity(
                  r.title,
                  r.description,
                  r.category,
                  controlLevel: r.controlLevel,
                  urgency: r.urgency,
                  reason: r.reason,
                ).label ==
                'Low',
          )
          .length,
    };
  }

  // Get recent risks
  static List<RiskEntry> getRecentRisks(List<RiskEntry> risks, {int days = 7}) {
    DateTime cutoff = DateTime.now().subtract(Duration(days: days));
    return risks.where((r) => r.date.isAfter(cutoff)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get risk for each date
  static List<RiskEntry> getRisksForDate(List<RiskEntry> risks, DateTime date) {
    return risks
        .where(
          (r) =>
              r.date.year == date.year &&
              r.date.month == date.month &&
              r.date.day == date.day,
        )
        .toList();
  }

  // Get day with risks
  static List<DateTime> getDatesWithRisks(List<RiskEntry> risks) {
    return risks
        .map((r) => DateTime(r.date.year, r.date.month, r.date.day))
        .toSet()
        .toList();
  }

  // Algorithm 6: Monthly and weekly trend analysis
  int getWeeklyFrequency(RiskEntry risk, List<RiskEntry> allRisks) {
    final riskDate = risk.date;

    final weekStart = riskDate.subtract(
      Duration(days: riskDate.weekday - 1),
    );
    final weekEnd = weekStart.add(const Duration(days: 6));

    final targetCode = RiskLogicEngine.detectBehavioralPatterns(risk);

    return allRisks.where((r) {
      final code = RiskLogicEngine.detectBehavioralPatterns(r);
      return r.date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
            r.date.isBefore(weekEnd.add(const Duration(days: 1))) &&
            code == targetCode;
    }).length;
  }

  int getMonthlyFrequency(RiskEntry risk, List<RiskEntry> allRisks) {
    final riskDate = risk.date;

    final monthStart = DateTime(riskDate.year, riskDate.month, 1);
    final monthEnd = DateTime(riskDate.year, riskDate.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    final targetCode = RiskLogicEngine.detectBehavioralPatterns(risk);

    return allRisks.where((r) {
      final code = RiskLogicEngine.detectBehavioralPatterns(r);
      return r.date.isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
            r.date.isBefore(monthEnd.add(const Duration(seconds: 1))) &&
            code == targetCode;
    }).length;
  }
}
