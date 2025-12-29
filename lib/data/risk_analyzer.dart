import 'package:everyday_risk_analyzer/models/risk.dart';

class RiskLogicEngine {
  // Mock data
  static List<RiskEntry> mockRisks = [
    RiskEntry(
      id: '1',
      title: 'Slept at 3 AM',
      description: 'Sleep deprivation - Health',
      category: 'Health',
      severity: 'High',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    RiskEntry(
      id: '2',
      title: 'Skipped breakfast',
      description: 'Meal skipping - Health',
      category: 'Health',
      severity: 'Medium',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    RiskEntry(
      id: '3',
      title: 'Forgot to hydrate',
      description: 'Dehydration - Health',
      category: 'Health',
      severity: 'Low',
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    RiskEntry(
      id: '4',
      title: 'Rode bike without helmet',
      description: 'Safety neglect - Safety',
      category: 'Safety',
      severity: 'High',
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    RiskEntry(
      id: '5',
      title: 'Overspending',
      description: 'Financial risk - Finance',
      category: 'Finance',
      severity: 'High',
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

  // Calculate Summary for each week (for each category)
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

  // Calculate overal risks (for each risk category with score indicate)
  static String calculateOverallRisk(List<RiskEntry> risks) {
    int highCount = risks.where((r) => r.severity == 'High').length;
    int mediumCount = risks.where((r) => r.severity == 'Medium').length;
    int lowCount = risks.where((r) => r.severity == 'Low').length;

    double score = (highCount * 3) + (mediumCount * 2) + (lowCount * 1); //Check the logic again

    // Check logic for this part too
    if (score > 20) return 'High';
    if (score > 10) return 'Medium';
    return 'Low';
  }

  // Calculate to show number of risk category
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

  // Calculate recent risk (in a week)
  static List<RiskEntry> getRecentRisks(List<RiskEntry> risks, {int days = 7}) {
    DateTime cutoff = DateTime.now().subtract(Duration(days: days));
    return risks.where((r) => r.date.isAfter(cutoff)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get risk for each day
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

  // Get day with risk
  static List<DateTime> getDatesWithRisks(List<RiskEntry> risks) {
    return risks
        .map((r) => DateTime(r.date.year, r.date.month, r.date.day))
        .toSet()
        .toList();
  }

  // Check this part again too
  // Risk recommendation for each summary
  static String getRiskRecommendation(List<RiskEntry> risks) {
    var summary = calculateWeeklySummary(risks);
    int total =
        (summary['health'] ?? 0) +
        (summary['finance'] ?? 0) +
        (summary['safety'] ?? 0);

    if (total > 15) {
      return '⚠️ CRITICAL: You have taken too many risks this week. Please reduce risky behaviors immediately.';
    } else if (total > 10) {
      return '⚡ HIGH: Your risk level is elevated. Consider reducing risky activities.';
    } else if (total > 5) {
      return '📊 MODERATE: You have moderate risk exposure. Stay vigilant.';
    } else {
      return '✅ GOOD: You are maintaining a healthy risk level. Keep it up!';
    }
  }
}
