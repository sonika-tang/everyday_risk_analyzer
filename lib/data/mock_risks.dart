import 'dart:convert';
import 'dart:io';

import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/models/user.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  // Get the local path
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get the file
  static Future<File> _getFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  // Save risks
  static Future<void> saveRisks(List<RiskEntry> risks) async {
    final file = await _getFile('risks.json');
    final json = jsonEncode(risks.map((r) => r.toJson()).toList());
    await file.writeAsString(json);
  }

  // Load risks
  static Future<List<RiskEntry>> loadRisks() async {
    try {
      final file = await _getFile('risks.json');
      if (!await file.exists()) {
        return _getDefaultMockRisks();
      }
      final json = await file.readAsString();
      return (jsonDecode(json) as List)
          .map((r) => RiskEntry.fromJson(r))
          .toList();
    } catch (e) {
      return _getDefaultMockRisks();
    }
  }

  // Get Mock risk (can change to UUID for the ID)
  static List<RiskEntry> _getDefaultMockRisks() {
    DateTime now = DateTime.now();
    return [
      RiskEntry(
        id: '1',
        title: 'Slept at 3 AM',
        description: 'Sleep deprivation - Health',
        category: 'Health',
        severity: 'High',
        date: now.subtract(Duration(days: 1)),
        createdAt: now.subtract(Duration(days: 2)),
      ),
      RiskEntry(
        id: '2',
        title: 'Skipped breakfast',
        description: 'Meal skipping - Health',
        category: 'Health',
        severity: 'Medium',
        date: now.subtract(Duration(days: 1)),
        createdAt: now.subtract(Duration(days: 2)),
        frequency: 3,
      ),
      RiskEntry(
        id: '3',
        title: 'Forgot to hydrate',
        description: 'Dehydration - Health',
        category: 'Health',
        severity: 'Low',
        date: now.subtract(Duration(days: 2)),
        createdAt: now.subtract(Duration(days: 3)),
      ),
      RiskEntry(
        id: '4',
        title: 'Rode bike without helmet',
        description: 'Safety neglect - Safety',
        category: 'Safety',
        severity: 'High',
        date: now.subtract(Duration(days: 2)),
        createdAt: now.subtract(Duration(days: 3)),
      ),
      RiskEntry(
        id: '5',
        title: 'Overspending',
        description: 'Financial risk - Finance',
        category: 'Finance',
        severity: 'High',
        date: now.subtract(Duration(days: 3)),
        createdAt: now.subtract(Duration(days: 4)),
        frequency: 2,
      ),
    ];
  }

  // Save profile
  static Future<void> saveProfile(UserProfile profile) async {
    final file = await _getFile('profile.json');
    await file.writeAsString(jsonEncode(profile.toJson()));
  }

  // load profile
  static Future<UserProfile> loadProfile() async {
    try {
      final file = await _getFile('profile.json');
      if (!await file.exists()) {
        final defaultProfile = UserProfile(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}', // Can change to UUID
          name: 'Nika',
          email: 'sonika@gmail.com',
          createdAt: DateTime.now(),
        );
        await saveProfile(defaultProfile);
        return defaultProfile;
      }
      final json = await file.readAsString();
      return UserProfile.fromJson(jsonDecode(json));
    } catch (e) {
      final defaultProfile = UserProfile(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}', // Can change to UUID
        name: 'Nika',
        email: 'sonika@gmail.com',
        createdAt: DateTime.now(),
      );
      return defaultProfile;
    }
  }

  // add risk
  static Future<void> addRisk(RiskEntry risk) async {
    final risks = await loadRisks();
    risks.add(risk);
    await saveRisks(risks);
  }

  // update risk
  static Future<void> updateRisk(RiskEntry risk) async {
    final risks = await loadRisks();
    final index = risks.indexWhere((r) => r.id == risk.id);
    if (index != -1) {
      risks[index] = risk;
      await saveRisks(risks);
    }
  }

  // delete risk
  static Future<void> deleteRisk(String id) async {
    final risks = await loadRisks();
    risks.removeWhere((r) => r.id == id);
    await saveRisks(risks);
  }
}
