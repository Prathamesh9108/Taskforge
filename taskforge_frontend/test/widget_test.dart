import 'package:flutter_test/flutter_test.dart';
import 'package:taskforge_frontend/main.dart';

void main() {
  testWidgets('TaskForgeApp launches and renders splash and dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskForgeApp());

    // Verify initial splash state
    expect(find.text('TaskForge'), findsOneWidget);

    // Let the timer fire and transition to DashboardScreen
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify dashboard screen has loaded
    expect(find.text('Workspace'), findsOneWidget);
  });
}
