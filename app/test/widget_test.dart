// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: Text('Test App')));
  }
}

void main() {
  testWidgets('App Creates', (WidgetTester tester) async {
    await tester.pumpWidget(const TestWidget()); //error over here

    final titleFinder = find.text('Test App');

    expect(titleFinder, findsOneWidget);
  });
}
