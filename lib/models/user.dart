class UserProfile {
  String id;
  String name;
  String email;
  DateTime createdAt;
  bool isDarkMode;
  Map<String, dynamic> preferences;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.isDarkMode = false,
    this.preferences = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'createdAt': createdAt.toIso8601String(),
    'isDarkMode': isDarkMode,
    'preferences': preferences,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
    name: json['name'] ?? 'User',
    email: json['email'] ?? 'user@gmail.com',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    isDarkMode: json['isDarkMode'] ?? true,
    preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
  );
}