import 'dart:convert';
import 'package:everyday_risk_analyzer/data/risk_analyzer.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String risksKey = 'risks';
  static const String profileKey = 'profile';

  static Future<void> saveRisks(List<RiskEntry> risks) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(risks.map((r) => r.toJson()).toList());
    await prefs.setString(risksKey, json);
  }

  static Future<List<RiskEntry>> loadRisks() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(risksKey);
    if (json == null) return RiskLogicEngine.mockRisks;
    return (jsonDecode(json) as List).map((r) => RiskEntry.fromJson(r)).toList();
  }

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(profileKey, jsonEncode(profile.toJson()));
  }

  static Future<UserProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(profileKey);
    if (json == null) {
      return UserProfile(name: 'Nika', email: 'sonika@gmail.com', avatarUrl: '');
    }
    return UserProfile.fromJson(jsonDecode(json));
  }

  static Future<void> addRisk(RiskEntry risk) async {
    final risks = await loadRisks();
    risks.add(risk);
    await saveRisks(risks);
  }

  static Future<void> deleteRisk(String id) async {
    final risks = await loadRisks();
    risks.removeWhere((r) => r.id == id);
    await saveRisks(risks);
  }
}