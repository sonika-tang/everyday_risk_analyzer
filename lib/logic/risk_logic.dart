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
  
  static String calculateRiskFor(List<RiskEntry> risks) {
    if (risks.isEmpty) return 'None';

    Map<String, int> categoryImpact = {
      'Health': 0,
      'Finance': 0,
      'Safety': 0,
    };

    for (var risk in risks) {
      final severity = SeverityCalculator.calculateSeverity(
        risk.title,
        risk.description,
        risk.category,
        controlLevel: risk.controlLevel,
        urgency: risk.urgency,
        reason: risk.reason,
      );
      categoryImpact[risk.category] =
          (categoryImpact[risk.category] ?? 0) + severity.weight;
    }

    return categoryImpact.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
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
      return behaviorPatterns.any((pattern) =>
          pattern.code == behaviorCode &&
          pattern.keywords.any((kw) => text.contains(kw)));
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
  static Map<String, dynamic> detectBehavioralPatterns(List<RiskEntry> risks) {
    Map<String, int> weeklyFrequency = {};
    Map<String, int> monthlyFrequency = {};
    Map<String, List<RiskEntry>> riskClusters = {
      'Health': [],
      'Safety': [],
      'Finance': [],
    };
    List<String> anomalies = [];

    DateTime now = DateTime.now();

    // --- Weekly boundaries (current calendar week: Monday–Sunday) ---
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    DateTime weekEnd = weekStart.add(const Duration(days: 6));

    // --- Monthly boundaries (current calendar month) ---
    DateTime monthStart = DateTime(now.year, now.month, 1);
    DateTime monthEnd = DateTime(now.year, now.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    // Filter weekly and monthly risks
    List<RiskEntry> weeklyRisks = risks.where((r) =>
      r.date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
      r.date.isBefore(weekEnd.add(const Duration(days: 1)))
    ).toList();

    List<RiskEntry> monthlyRisks = risks.where((r) =>
      r.date.isAfter(monthStart.subtract(const Duration(seconds: 1))) &&
      r.date.isBefore(monthEnd.add(const Duration(seconds: 1)))
    ).toList();

    // --- Weekly frequency ---
    for (var risk in weeklyRisks) {
      String combined = ('${risk.title} ${risk.description}').toLowerCase();
      String behaviorCode = 'UNCLASSIFIED';
      for (final pattern in behaviorPatterns) {
        if (pattern.keywords.any((kw) => combined.contains(kw))) {
          behaviorCode = pattern.code;
          break;
        }
      }
      weeklyFrequency[behaviorCode] = (weeklyFrequency[behaviorCode] ?? 0) + 1;
      riskClusters[risk.category]?.add(risk);
    }

    // --- Monthly frequency ---
    for (var risk in monthlyRisks) {
      String combined = ('${risk.title} ${risk.description}').toLowerCase();
      String behaviorCode = 'UNCLASSIFIED';
      for (final pattern in behaviorPatterns) {
        if (pattern.keywords.any((kw) => combined.contains(kw))) {
          behaviorCode = pattern.code;
          break;
        }
      }
      monthlyFrequency[behaviorCode] = (monthlyFrequency[behaviorCode] ?? 0) + 1;
    }

    // --- Anomaly detection ---
    weeklyFrequency.forEach((code, count) {
      if (count > 5) anomalies.add('Weekly anomaly: $code repeated $count times');
    });
    monthlyFrequency.forEach((code, count) {
      if (count > 10) anomalies.add('Monthly anomaly: $code repeated $count times');
    });

    // --- Cluster detection (weekly clusters) ---
    if ((riskClusters['Health']?.length ?? 0) > 3) {
      anomalies.add('Health Cluster: ${riskClusters['Health']?.length} health risks this week');
    }
    if ((riskClusters['Safety']?.length ?? 0) > 3) {
      anomalies.add('Safety Cluster: ${riskClusters['Safety']?.length} safety risks this week');
    }
    if ((riskClusters['Finance']?.length ?? 0) > 3) {
      anomalies.add('Finance Cluster: ${riskClusters['Finance']?.length} finance risks this week');
    }

    return {
      'weeklyFrequency': weeklyFrequency,
      'monthlyFrequency': monthlyFrequency,
      'clusters': riskClusters,
      'anomalies': anomalies,
    };
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
  static Map<String, dynamic> compareCategoryFrequencies(List<RiskEntry> risks) {
    DateTime now = DateTime.now();

    // --- Define week boundaries ---
    DateTime thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    DateTime thisWeekEnd = thisWeekStart.add(const Duration(days: 6));

    DateTime lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    DateTime lastWeekEnd = thisWeekStart.subtract(const Duration(days: 1));

    // --- Separate risks ---
    List<RiskEntry> thisWeekRisks = risks.where((r) =>
      r.date.isAfter(thisWeekStart.subtract(const Duration(seconds: 1))) &&
      r.date.isBefore(thisWeekEnd.add(const Duration(days: 1)))
    ).toList();

    List<RiskEntry> lastWeekRisks = risks.where((r) =>
      r.date.isAfter(lastWeekStart.subtract(const Duration(seconds: 1))) &&
      r.date.isBefore(lastWeekEnd.add(const Duration(days: 1)))
    ).toList();

    // --- Count by category ---
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

    // --- Build comparison ---
    Map<String, String> comparison = {};
    for (var category in ['Health', 'Safety', 'Finance']) {
      int last = lastWeekCounts[category] ?? 0;
      int current = thisWeekCounts[category] ?? 0;
      int diff = current - last;

      if (diff > 0) {
        comparison[category] = '↑ Increased by $diff (from $last to $current)';
      } else if (diff < 0) {
        comparison[category] = '↓ Decreased by ${diff.abs()} (from $last to $current)';
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
      if (!risk.date.isBefore(weekStart) &&
          !risk.date.isAfter(weekEnd)) {
        if (risk.category == 'Health') health++;
        if (risk.category == 'Finance') finance++;
        if (risk.category == 'Safety') safety++;
      }
    }

    return {
      'Health': health,
      'Finance': finance,
      'Safety': safety,
    };
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
      'high': catRisks.where((r) =>
        SeverityCalculator.calculateSeverity(
          r.title,
          r.description,
          r.category,
          controlLevel: r.controlLevel,
          urgency: r.urgency,
          reason: r.reason,
        ).label == 'High'
      ).length,
      'medium': catRisks.where((r) =>
        SeverityCalculator.calculateSeverity(
          r.title,
          r.description,
          r.category,
          controlLevel: r.controlLevel,
          urgency: r.urgency,
          reason: r.reason,
        ).label == 'Medium'
      ).length,
      'low': catRisks.where((r) =>
        SeverityCalculator.calculateSeverity(
          r.title,
          r.description,
          r.category,
          controlLevel: r.controlLevel,
          urgency: r.urgency,
          reason: r.reason,
        ).label == 'Low'
      ).length,
    };
  }

  // Get recent risks
  static List<RiskEntry> getRecentRisks(List<RiskEntry> risks, {int days = 8}) {
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
    DateTime now = DateTime.now();
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    DateTime weekEnd = weekStart.add(const Duration(days: 6));

    return allRisks.where((r) =>
      r.date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
      r.date.isBefore(weekEnd.add(const Duration(days: 1))) &&
      r.title.toLowerCase() == risk.title.toLowerCase()
    ).length;
  }

  int getMonthlyFrequency(RiskEntry risk, List<RiskEntry> allRisks) {
    DateTime now = DateTime.now();
    return allRisks.where((r) =>
      r.date.year == now.year &&
      r.date.month == now.month &&
      r.title.toLowerCase() == risk.title.toLowerCase()
    ).length;
  }
}
