import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nidly/screens/onboarding_screen.dart';

void main() {
  testWidgets('Onboarding shows the Nidly welcome copy',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: OnboardingScreen()),
    );

    expect(find.text('Bienvenue sur Nidly'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
  });
}
