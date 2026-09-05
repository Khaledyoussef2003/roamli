import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roamli/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('ROAMLI launches in light mode', (tester) async {
    SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
    await tester.pumpWidget(const RoamliApp());
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('ROAMLI'), findsOneWidget);
    expect(find.text('Your trip. Your way.'), findsOneWidget);
  });

  testWidgets('ROAMLI supports dark mode preference', (tester) async {
    SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
    await tester.pumpWidget(const RoamliApp());
    await tester.pump(const Duration(milliseconds: 100));
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });
}
