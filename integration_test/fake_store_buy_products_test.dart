import 'package:fake_store/main.dart' as app;
import 'package:fake_store/presentation/pages.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    "It should only allow the purchase when the user is authenticated.",
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // Find one element by id
      final scrollables = find.byType(Scrollable).evaluate();
      final verticalScrollable = scrollables.firstWhere((element) {
        final scrollable = element.widget as Scrollable;

        return scrollable.axisDirection == AxisDirection.down;
      });

      final verticalScrollableFinder = find.byWidget(verticalScrollable.widget);

      await tester.scrollUntilVisible(
        find.byKey(ValueKey("ProductHome10")),
        500.0,
        scrollable: verticalScrollableFinder,
      );

      await tester.pumpAndSettle();

      // Add firts element to the cart List
      await tester.tap(
        find.descendant(
          of: find.byKey(ValueKey("ProductHome10")),
          matching: find.byType(TextButton),
        ),
      );

      // Navigate to the cartscreen
      await tester.tap(find.byIcon(AppIcons.cart));
      await tester.pumpAndSettle();
      expect(find.byType(CartScreen), findsOneWidget);

      // Navigate to the floating  notification
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialog), findsOneWidget);

      // Navigate to the loginscreen
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);

      // Authentication process
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

      // Increase the amount of products
      await tester.tap(
        find.descendant(
          of: find.byKey(ValueKey("ProductCartContainer-0")),
          matching: find.byIcon(AppIcons.plus),
        ),
      );
      await tester.pumpAndSettle();
      // buy the  products
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      // finish the purchase
      await tester.tap(find.text('Continue Shopping'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );
}
