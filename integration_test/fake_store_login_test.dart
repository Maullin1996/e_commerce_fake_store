import 'package:fake_store/main.dart' as app;
import 'package:fake_store/presentation/pages.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("test description", (WidgetTester tester) async {
    app.main();

    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    // Navigate to the login screen
    await tester.tap(find.byIcon(AppIcons.login));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);

    // Find text inputs

    await tester.drag(find.byType(AppAssetsImage), const Offset(0, 200));
    await tester.pumpAndSettle();

    // Enter user
    await tester.tap(find.byKey(ValueKey('username')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(ValueKey('username')), 'johnd');
    await tester.pumpAndSettle();

    // Find password enter text
    await tester.drag(find.byType(AppAssetsImage), const Offset(0, -200));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(ValueKey('password')), 'm38rmF\$');
    await tester.pumpAndSettle();
    // clouse the keyboard
    await tester.tapAt(Offset(100, 200));
    await tester.pumpAndSettle();

    // Tap at the enter button
    await tester.tap(find.byKey(ValueKey('enter button')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsNothing);

    await tester.tap(find.byIcon(AppIcons.user));
    await tester.pumpAndSettle();

    expect(find.byType(UserScreen), findsOneWidget);
  });
}
