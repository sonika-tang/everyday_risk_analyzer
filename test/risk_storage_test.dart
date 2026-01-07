import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:everyday_risk_analyzer/data/risk_storage_service.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';

void main() {
  group('RiskStorageService Tests', () {
    setUp(() async {
      // Initialize shared preferences for testing
      SharedPreferences.setMockInitialValues({});
      await RiskStorageService.clearAll();
    });

    // Test Case 1: Add Risk Successfully
    test('TC1: Should add risk to storage successfully', () async {
      final newRisk = RiskEntry(
        id: '1',
        title: 'Skipped Breakfast',
        description: 'Did not eat breakfast',
        category: 'Health',
        severity: 'Low',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        controlLevel: 'Fully Avoidable',
        reason: 'Forgot',
        urgency: 'Calm',
      );

      await RiskStorageService.addRisk(newRisk);
      final risks = await RiskStorageService.getRisks();

      expect(risks.length, equals(1));
      expect(risks[0].id, equals('1'));
      expect(risks[0].title, equals('Skipped Breakfast'));
    });

    // Test Case 2: Delete Risk Successfully
    test('TC2: Should delete risk from storage', () async {
      final risk1 = RiskEntry(
        id: '1',
        title: 'Risk 1',
        description: 'Description 1',
        category: 'Health',
        severity: 'Low',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        controlLevel: 'Fully Avoidable',
        reason: 'Forgot',
        urgency: 'Calm',
      );

      final risk2 = RiskEntry(
        id: '2',
        title: 'Risk 2',
        description: 'Description 2',
        category: 'Safety',
        severity: 'Medium',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        controlLevel: 'Partially',
        reason: 'Careless',
        urgency: 'Calm',
      );

      await RiskStorageService.addRisk(risk1);
      await RiskStorageService.addRisk(risk2);

      var risks = await RiskStorageService.getRisks();
      expect(risks.length, equals(2));

      await RiskStorageService.deleteRisk('1');
      risks = await RiskStorageService.getRisks();

      expect(risks.length, equals(1));
      expect(risks[0].id, equals('2'));
    });

    // Test Case 3: Retrieve All Risks
    test('TC3: Should retrieve all stored risks', () async {
      final risks = [
        RiskEntry(
          id: '1',
          title: 'Risk 1',
          description: 'Description 1',
          category: 'Health',
          severity: 'Low',
          date: DateTime.now(),
          createdAt: DateTime.now(),
          controlLevel: 'Fully Avoidable',
          reason: 'Forgot',
          urgency: 'Calm',
        ),
        RiskEntry(
          id: '2',
          title: 'Risk 2',
          description: 'Description 2',
          category: 'Safety',
          severity: 'Medium',
          date: DateTime.now(),
          createdAt: DateTime.now(),
          controlLevel: 'Partially',
          reason: 'Careless',
          urgency: 'Calm',
        ),
        RiskEntry(
          id: '3',
          title: 'Risk 3',
          description: 'Description 3',
          category: 'Finance',
          severity: 'High',
          date: DateTime.now(),
          createdAt: DateTime.now(),
          controlLevel: 'Unavoidable',
          reason: 'Financial',
          urgency: 'Emergency',
        ),
      ];

      for (var risk in risks) {
        await RiskStorageService.addRisk(risk);
      }

      final retrievedRisks = await RiskStorageService.getRisks();
      expect(retrievedRisks.length, equals(3));
    });

    // Test Case 4: Empty Storage Handling
    test('TC4: Should return empty list when storage is empty', () async {
      final risks = await RiskStorageService.getRisks();
      expect(risks.isEmpty, true);
    });

    // Test Case 5: Risk JSON Serialization
    test('TC5: Should serialize and deserialize risk correctly', () async {
      final originalRisk = RiskEntry(
        id: 'test-id-123',
        title: 'Test Risk',
        description: 'This is a test risk with full details',
        category: 'Health',
        severity: 'High',
        date: DateTime(2025, 1, 7),
        createdAt: DateTime(2025, 1, 6),
        frequency: 5,
        controlLevel: 'Fully Avoidable',
        reason: 'Stress',
        urgency: 'Emergency',
      );

      // Convert to JSON
      final json = originalRisk.toJson();

      // Convert back from JSON
      final deserializedRisk = RiskEntry.fromJson(json);

      expect(deserializedRisk.id, equals(originalRisk.id));
      expect(deserializedRisk.title, equals(originalRisk.title));
      expect(deserializedRisk.description, equals(originalRisk.description));
      expect(deserializedRisk.category, equals(originalRisk.category));
      expect(deserializedRisk.severity, equals(originalRisk.severity));
      expect(deserializedRisk.frequency, equals(originalRisk.frequency));
      expect(deserializedRisk.controlLevel, equals(originalRisk.controlLevel));
      expect(deserializedRisk.reason, equals(originalRisk.reason));
      expect(deserializedRisk.urgency, equals(originalRisk.urgency));
    });

    // Test Case 6: Delete Non-existent Risk
    test('TC6: Should handle deletion of non-existent risk gracefully', () async {
      final risk = RiskEntry(
        id: '1',
        title: 'Test Risk',
        description: 'Description',
        category: 'Health',
        severity: 'Low',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        controlLevel: 'Fully Avoidable',
        reason: 'Forgot',
        urgency: 'Calm',
      );

      await RiskStorageService.addRisk(risk);
      await RiskStorageService.deleteRisk('non-existent-id');

      final risks = await RiskStorageService.getRisks();
      expect(risks.length, equals(1));
    });

    // Test Case 7: Clear All Risks
    test('TC7: Should clear all risks from storage', () async {
      final risk1 = RiskEntry(
        id: '1',
        title: 'Risk 1',
        description: 'Description 1',
        category: 'Health',
        severity: 'Low',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        controlLevel: 'Fully Avoidable',
        reason: 'Forgot',
        urgency: 'Calm',
      );

      final risk2 = RiskEntry(
        id: '2',
        title: 'Risk 2',
        description: 'Description 2',
        category: 'Safety',
        severity: 'Medium',
        date: DateTime.now(),
        createdAt: DateTime.now(),
        controlLevel: 'Partially',
        reason: 'Careless',
        urgency: 'Calm',
      );

      await RiskStorageService.addRisk(risk1);
      await RiskStorageService.addRisk(risk2);

      var risks = await RiskStorageService.getRisks();
      expect(risks.length, equals(2));

      await RiskStorageService.clearAll();
      risks = await RiskStorageService.getRisks();

      expect(risks.isEmpty, true);
    });

    // Test Case 8: Verify User Profile Retrieval
    test('TC8: Should retrieve user profile', () async {
      final profile = await RiskStorageService.getProfile();

      expect(profile.id.isNotEmpty, true);
      expect(profile.name.isNotEmpty, true);
      expect(profile.email.isNotEmpty, true);
      expect(profile.createdAt, isNotNull);
    });
  });
}