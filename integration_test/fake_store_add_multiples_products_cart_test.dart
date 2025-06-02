import 'package:fake_store/main.dart' as app;
import 'package:fake_store/presentation/pages/cart_screen.dart';
import 'package:fake_store/presentation/pages/home_screen.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Should add Various elements to the cart", (
    WidgetTester tester,
  ) async {
    app.main();

    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    // Add firts element to the cart List
    await tester.tap(
      find.descendant(
        of: find.byKey(ValueKey("ProductHome1")),
        matching: find.byType(TextButton),
      ),
    );

    // Find one element by id
    final scrollables = find.byType(Scrollable).evaluate();
    final verticalScrollable = scrollables.firstWhere((element) {
      final scrollable = element.widget as Scrollable;

      return scrollable.axisDirection == AxisDirection.down;
    });

    final verticalScrollableFinder = find.byWidget(verticalScrollable.widget);

    await tester.scrollUntilVisible(
      find.byKey(ValueKey("ProductHome6")),
      500.0,
      scrollable: verticalScrollableFinder,
    );

    await tester.pumpAndSettle();

    // Add second element to the cart List
    await tester.tap(
      find.descendant(
        of: find.byKey(ValueKey("ProductHome6")),
        matching: find.byType(TextButton),
      ),
    );

    // Find one element by id
    await tester.scrollUntilVisible(
      find.byKey(ValueKey("ProductHome15")),
      500.0,
    );

    await tester.pumpAndSettle();

    // Add third element to the cart List
    await tester.tap(
      find.descendant(
        of: find.byKey(ValueKey("ProductHome15")),
        matching: find.byType(TextButton),
      ),
    );

    // go to the cartScreen
    await tester.tap(find.byIcon(AppIcons.cart));
    await tester.pumpAndSettle();
    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.byType(ProductCartContainer), findsNWidgets(3));
  });
}
