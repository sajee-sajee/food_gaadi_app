import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_gaadi/screens/Orders_page.dart';

void main() {
  testWidgets('Orders demo switches to empty history', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrdersPage()));
    expect(find.text('Orders · Demo'), findsOneWidget);
    expect(find.text('#2035'), findsOneWidget);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('#2035'), findsNothing);
    expect(find.byIcon(Icons.history_toggle_off), findsOneWidget);
  });
}
