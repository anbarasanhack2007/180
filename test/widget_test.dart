import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybersprint180/core/widgets/cyber_button.dart';
import 'package:cybersprint180/data/models/curriculum_models.dart';
import 'package:cybersprint180/data/models/profile_model.dart';
import 'package:cybersprint180/domain/entities/progress.dart';

void main() {
  group('CyberSprint 180 Smoke & Domain Tests', () {
    test('MonthModel JSON serialization works correctly', () {
      final json = {
        'id': 'm-1',
        'month_number': 1,
        'title': 'Networking Foundations',
        'description': 'TCP/IP and Wireshark',
        'objectives': ['Learn OSI model', 'Analyze packets'],
        'days_start': 1,
        'days_end': 30,
      };

      final model = MonthModel.fromJson(json);
      expect(model.id, 'm-1');
      expect(model.monthNumber, 1);
      expect(model.totalDays, 30);
      expect(model.objectives.length, 2);
    });

    test('ProfileModel default values and level calculation', () {
      final json = {
        'id': 'u-123',
        'full_name': 'Cadet Neo',
        'email': 'neo@cybersprint.io',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final profile = ProfileModel.fromJson(json);
      expect(profile.id, 'u-123');
      expect(profile.fullName, 'Cadet Neo');
      expect(profile.role, 'user');
      expect(profile.isAdmin, false);
      expect(profile.dailyGoalMinutes, 120);
    });

    test('UserProgress level computation logic', () {
      const p1 = UserProgress(userId: 'u1', xp: 50);
      expect(p1.level, 1);

      const p2 = UserProgress(userId: 'u1', xp: 350);
      expect(p2.level, 3);

      const p3 = UserProgress(userId: 'u1', xp: 12000);
      expect(p3.level, 12);
    });

    testWidgets('CyberButton renders label and triggers tap',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CyberButton(
                label: 'INITIALIZE ATTACK',
                onPressed: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('INITIALIZE ATTACK'), findsOneWidget);
      await tester.tap(find.byType(CyberButton));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
