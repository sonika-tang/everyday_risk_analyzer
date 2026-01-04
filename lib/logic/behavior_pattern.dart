class BehaviorPattern {
  final String code;       // Unique identifier
  final String category;   // Domain: Health, Safety, Finance
  final int baseWeight;    // Default severity weight
  final List<String> keywords; // Synonyms / triggers

  const BehaviorPattern({
    required this.code,
    required this.category,
    required this.baseWeight,
    required this.keywords,
  });
}
