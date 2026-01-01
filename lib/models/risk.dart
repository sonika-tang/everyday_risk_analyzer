// Check the model again too - cuz this is just a mock one that I can think of
class RiskEntry {
  String id;
  String title;
  String description;
  String category; // Health, Safety, Finance
  String severity; // Low, Medium, High
  DateTime date;
  DateTime createdAt;
  int frequency; // how many times user repeated this risk

  RiskEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.date,
    required this.createdAt,
    this.frequency = 1,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'severity': severity,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'frequency': frequency,
  };

  factory RiskEntry.fromJson(Map<String, dynamic> json) => RiskEntry(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    category: json['category'],
    severity: json['severity'],
    date: DateTime.parse(json['date']),
    createdAt: DateTime.parse(json['createdAt']),
    frequency: json['frequency'] ?? 1,
  );
}