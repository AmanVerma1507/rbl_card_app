import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rbl_card_home/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    // Pump the app — DI is set up inside RblCardHomeApp's first frame
    await tester.pumpWidget(const RblCardHomeApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
