// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads and shows the IPTV Home screen
    expect(find.text('IPTV Home'), findsOneWidget);
    
    // Check that main categories are present
    expect(find.text('EN VIVO'), findsOneWidget);
    expect(find.text('VOD'), findsOneWidget);
    expect(find.text('ESPECIAL'), findsOneWidget);
    expect(find.text('CANALES 24/7'), findsOneWidget);
  });

  testWidgets('Navigation to live channels works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the 'EN VIVO' button
    await tester.tap(find.text('EN VIVO'));
    await tester.pumpAndSettle();

    // Verify navigation to streaming home screen
    expect(find.text('Canales IPTV'), findsOneWidget);
  });
}
