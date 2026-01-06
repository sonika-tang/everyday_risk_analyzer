class SeverityResult {
  final String label; // "High", "Medium", "Low"
  final int weight;   // numeric weight for scoring

  const SeverityResult(this.label, this.weight);
}

class SeverityCalculator {
  // Auto-calculate severity based on title, description, category, controlLevel, reason, and urgency
  static SeverityResult calculateSeverity(
    String title,
    String description,
    String category, {
    String controlLevel = '',
    String urgency = '',
    String reason = '',
  }) {
    int riskScore = 0;

    // ControlLevel weighting
    int controlWeight(String controlLevel) {
      switch (controlLevel) {
        case 'Fully Avoidable': return 3;
        case 'Partially': return 2;
        case 'Unavoidable': return 1;
        default: return 0;
      }
    }

    // Urgency weighting
    int urgencyWeight(String urgency) {
      switch (urgency) {
        case 'Emergency': return 3;
        case 'Rushed': return 2;
        case 'Calm': return 1;
        default: return 0;
      }
    }

    // Reason weighting
    int reasonWeight(String reason) {
      final r = reason.toLowerCase();
      if (r.contains('stress')) return 2;
      if (r.contains('forgot')) return 1;
      if (r.contains('financial')) return 2;
      if (r.contains('careless')) return 2;
      return 0;
    }

    // Category-based scoring
    if (category == 'Health') riskScore += 2;
    if (category == 'Safety') riskScore += 2;
    if (category == 'Finance') riskScore += 1;

    // Longer descriptions suggest more serious issues
    if (description.length > 50) riskScore += 3;

    // Apply controlLevel, urgency, reason
    riskScore += controlWeight(controlLevel);
    riskScore += urgencyWeight(urgency);
    riskScore += reasonWeight(reason);

    // Clamp
    riskScore = riskScore.clamp(0, 20);

    // Return both label + weight
    if (riskScore >= 8) return SeverityResult('High', 15);
    if (riskScore >= 4) return SeverityResult('Medium', 8);
    return SeverityResult('Low', 3);
  }
}
