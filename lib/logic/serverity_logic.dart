class SeverityCalculator {
  // Auto-calculate severity based on title and description analysis
  static String calculateSeverity(
    String title,
    String description,
    String category,
  ) {
    String combined = ('$title $description').toLowerCase();
    int riskScore = 0;

    // Keywords analysis
    final highRiskKeywords = [
      'critical',
      'severe',
      'emergency',
      'accident',
      'dangerous',
      'collapsed',
      'extreme',
      'serious',
      'fatal',
      'broken',
      'injured',
      'overdose',
      'bankruptcy',
    ];

    final mediumRiskKeywords = [
      'skipped',
      'forgot',
      'missed',
      'ignored',
      'avoid',
      'reckless',
      'careless',
      'overspent',
      'debt',
      'stress',
      'anxiety',
      'tired',
      'dehydration',
      'weak',
    ];

    // Check high risk keywords
    for (var keyword in highRiskKeywords) {
      if (combined.contains(keyword)) {
        riskScore += 3;
      }
    }

    // Check medium risk keywords
    for (var keyword in mediumRiskKeywords) {
      if (combined.contains(keyword)) {
        riskScore += 2;
      }
    }

    // Category-based scoring
    if (category == 'Health') riskScore += 2;
    if (category == 'Safety') riskScore += 2;
    if (category == 'Finance') riskScore += 1;

    // Length consideration - longer descriptions suggest more serious issues
    if (description.length > 50) riskScore += 3;

    // Determine severity
    if (riskScore >= 8) return 'High';
    if (riskScore >= 4) return 'Medium';
    return 'Low';
  }
}
