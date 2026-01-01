// Check the model again too - cuz this is just a mock one that I can think of
class RiskStatistics {
  String id;
  DateTime generatedAt;
  int totalRisks;
  int highRiskCount;
  int mediumRiskCount;
  int lowRiskCount;
  Map<String, int> risksByCategory;
  double overallRiskScore;
  String recommendation;

  RiskStatistics({
    required this.id,
    required this.generatedAt,
    required this.totalRisks,
    required this.highRiskCount,
    required this.mediumRiskCount,
    required this.lowRiskCount,
    required this.risksByCategory,
    required this.overallRiskScore,
    required this.recommendation,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'generatedAt': generatedAt.toIso8601String(),
    'totalRisks': totalRisks,
    'highRiskCount': highRiskCount,
    'mediumRiskCount': mediumRiskCount,
    'lowRiskCount': lowRiskCount,
    'risksByCategory': risksByCategory,
    'overallRiskScore': overallRiskScore,
    'recommendation': recommendation,
  };

  factory RiskStatistics.fromJson(Map<String, dynamic> json) => RiskStatistics(
    id: json['id'],
    generatedAt: DateTime.parse(json['generatedAt']),
    totalRisks: json['totalRisks'],
    highRiskCount: json['highRiskCount'],
    mediumRiskCount: json['mediumRiskCount'],
    lowRiskCount: json['lowRiskCount'],
    risksByCategory: Map<String, int>.from(json['risksByCategory']),
    overallRiskScore: json['overallRiskScore'].toDouble(),
    recommendation: json['recommendation'],
  );
}