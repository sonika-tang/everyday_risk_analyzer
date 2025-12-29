// Check the model again too - cuz this is just a mock one that I can think of
class RiskEntry {
  String id;
  String title;
  String description;
  String category; // Health, Safety, Finance
  String severity; // Low, Medium, High
  DateTime date;


  RiskEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'severity': severity,
    'date': date.toIso8601String(),
  };

  factory RiskEntry.fromJson(Map<String, dynamic> json) => RiskEntry(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    category: json['category'],
    severity: json['severity'],
    date: DateTime.parse(json['date']),
  );
}

class UserProfile {
  String name;
  String email;
  String avatarUrl;
  Map<String, int> riskThresholds;
  List<String> tags;
  bool isDarkMode;

  UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.riskThresholds = const {},
    this.tags = const [],
    this.isDarkMode = true,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'riskThresholds': riskThresholds,
    'tags': tags,
    'isDarkMode': isDarkMode,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] ?? 'User',
    email: json['email'] ?? 'user@gmail.com',
    avatarUrl: json['avatarUrl'] ?? '',
    riskThresholds: Map<String, int>.from(json['riskThresholds'] ?? {}),
    tags: List<String>.from(json['tags'] ?? []),
    isDarkMode: json['isDarkMode'] ?? true,
  );
}