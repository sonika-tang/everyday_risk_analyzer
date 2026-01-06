import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/risk.dart';
import '../models/user.dart';

class RiskStorageService {
  static const String _keyRiskList = 'risk_list';

  // Save a new risk (append to list)
  static Future<void> addRisk(RiskEntry risk) async {
    final prefs = await SharedPreferences.getInstance();
    List<RiskEntry> currentRisks = await getRisks();
    currentRisks.add(risk);
    await _saveList(prefs, currentRisks);
  }

  // Delete a risk by ID
  static Future<void> deleteRisk(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<RiskEntry> currentRisks = await getRisks();
    currentRisks.removeWhere((r) => r.id == id);
    await _saveList(prefs, currentRisks);
  }

  // Get all risks
  static Future<List<RiskEntry>> getRisks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyRiskList);
    if (jsonString == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => RiskEntry.fromJson(e)).toList();
    } catch (e) {
      // If error, return empty list (or could clear storage)
      return [];
    }
  }

  // Get user profile (mock for now, as in original code)
  static Future<UserProfile> getProfile() async {
    return UserProfile(
      id: 'U1',
      name: 'Nika',
      email: 'sonika@gmail.com',
      createdAt: DateTime.now(),
    );
  }

  // Clear all risks (debug/reset)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRiskList);
  }

  // Internal helper to save list
  static Future<void> _saveList(SharedPreferences prefs, List<RiskEntry> risks) async {
    final jsonString = jsonEncode(risks.map((r) => r.toJson()).toList());
    await prefs.setString(_keyRiskList, jsonString);
  }
}
