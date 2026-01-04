// ignore_for_file: constant_identifier_names

import 'package:everyday_risk_analyzer/logic/serverity_logic.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/models/risk_statistic.dart';
import 'package:everyday_risk_analyzer/data/behavior_patterns.dart';

class RiskLogicEngine {
  static const int CRITICAL_THRESHOLD = 20;
  static const int HIGH_THRESHOLD = 12;
  static const int MEDIUM_THRESHOLD = 5;

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

    String baseSeverity = risk.severity;

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

  // Algorithm 4: Predictive modeling - forecast next week's risk level
  static Map<String, dynamic> predictNextWeekRisk(List<RiskEntry> risks) {
    DateTime now = DateTime.now();
    DateTime lastWeekStart = now.subtract(Duration(days: 7));

    int lastWeekRisks = risks
        .where((r) => r.date.isAfter(lastWeekStart) && r.date.isBefore(now))
        .length;

    // Trend analysis: predict based on pattern
    int predictedRisks = (lastWeekRisks * 1.15)
        .toInt(); // 15% increase prediction

    String prediction = 'Based on last week: ~$predictedRisks risks expected';
    if (lastWeekRisks > CRITICAL_THRESHOLD) {
      prediction += ' - CRITICAL!';
    } else if (lastWeekRisks > HIGH_THRESHOLD) {
      prediction += ' - HIGH!';
    }

    return {
      'lastWeekCount': lastWeekRisks,
      'predictedCount': predictedRisks,
      'prediction': prediction,
      'confidence': 0.78,
    };
  }

  // Algorithm 5: Get customized recommendation based on risk profile
  static String getRecommendation(List<RiskEntry> risks) {
    double score = calculateRiskScore(risks);
    var patterns = detectBehavioralPatterns(risks);
    var weeklyTotal = calculateWeeklySummary(risks);
    int total =
        (weeklyTotal['health'] ?? 0) +
        (weeklyTotal['finance'] ?? 0) +
        (weeklyTotal['safety'] ?? 0);

    if (score >= 80) {
      return 'CRITICAL: You have taken way too many high-risk behaviors. Immediate action required to reduce risks.';
    } else if (score >= 60) {
      return 'SEVERE: Your risk level is dangerously high (${score.toStringAsFixed(0)}/100). Reduce risky behaviors now.';
    } else if (score >= 40) {
      return 'HIGH: Multiple risk patterns detected. ${(patterns['anomalies'] as List).length} concern(s) identified. Reduce activities.';
    } else if (score >= 25) {
      return 'MODERATE: You have $total risks this week. Stay vigilant and reduce exposure.';
    } else if (score > 0) {
      return 'GOOD: ${total > 0 ? "You have $total risks but managing well" : "You are maintaining a healthy lifestyle"}. Keep it up!';
    } else {
      return 'EXCELLENT: No risks recorded! Maintain this healthy lifestyle.';
    }
  }

  // Weekly summary
  static Map<String, int> calculateWeeklySummary(List<RiskEntry> risks) {
    DateTime now = DateTime.now();
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));

    int healthCount = 0;
    int financeCount = 0;
    int safetyCount = 0;

    for (var risk in risks) {
      if (risk.date.isAfter(weekStart) &&
          risk.date.isBefore(now.add(Duration(days: 1)))) {
        if (risk.category == 'Health') {
          healthCount++;
        } else if (risk.category == 'Finance') {
          financeCount++;
        } else if (risk.category == 'Safety') {
          safetyCount++;
        }
      }
    }

    return {
      'health': healthCount,
      'finance': financeCount,
      'safety': safetyCount,
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
      'high': catRisks.where((r) => r.severity == 'High').length,
      'medium': catRisks.where((r) => r.severity == 'Medium').length,
      'low': catRisks.where((r) => r.severity == 'Low').length,
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

  // Generate statistic
  static RiskStatistics generateStatistics(List<RiskEntry> risks) {
    var summary = calculateWeeklySummary(risks);
    int total =
        (summary['health'] ?? 0) +
        (summary['finance'] ?? 0) +
        (summary['safety'] ?? 0);
    int high = risks.where((r) => r.severity == 'High').length;
    int medium = risks.where((r) => r.severity == 'Medium').length;
    int low = risks.where((r) => r.severity == 'Low').length;

    return RiskStatistics(
      id: 'stat_${DateTime.now().millisecondsSinceEpoch}',
      generatedAt: DateTime.now(),
      totalRisks: total,
      highRiskCount: high,
      mediumRiskCount: medium,
      lowRiskCount: low,
      risksByCategory: summary.cast<String, int>(),
      overallRiskScore: calculateRiskScore(risks),
      recommendation: getRecommendation(risks),
    );
  }

  // Algorithm 6: Monthly trend analysis
  static Map<String, dynamic> getMonthlyTrend(
    List<RiskEntry> risks,
    int month,
    int year,
  ) {
    List<RiskEntry> monthRisks = risks
        .where((r) => r.date.year == year && r.date.month == month)
        .toList();

    int high = monthRisks.where((r) => r.severity == 'High').length;
    int medium = monthRisks.where((r) => r.severity == 'Medium').length;
    int low = monthRisks.where((r) => r.severity == 'Low').length;

    return {
      'total': monthRisks.length,
      'high': high,
      'medium': medium,
      'low': low,
      'avgPerDay': monthRisks.length / 30,
    };
  }

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
