import 'package:fake_store/main.dart' as app;
import 'package:fake_store/presentation/pages/home_screen.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Should add Various elements to the favorite list", (
    WidgetTester tester,
  ) async {
    app.main();

    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    // Add firts element to the favorite List
    await tester.tap(
      find.descendant(
        of: find.byKey(ValueKey("ProductHome1")),
        matching: find.byType(IconButton),
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

    // Add second element to the Favorite List
    await tester.tap(
      find.descendant(
        of: find.byKey(ValueKey("ProductHome6")),
        matching: find.byType(IconButton),
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
        matching: find.byType(IconButton),
      ),
    );

    // Find one element by id
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 3200));
    await tester.pumpAndSettle();

    // Find categorie
    final horizontalScrollable = scrollables.firstWhere((element) {
      final scrollable = element.widget as Scrollable;

      return scrollable.axisDirection == AxisDirection.right;
    });

    final horizontalScrollableScrollableFinder = find.byWidget(
      horizontalScrollable.widget,
    );

    await tester.scrollUntilVisible(
      find.descendant(
        of: find.byType(ListCategory),
        matching: find.text('Favorite'),
      ),
      500.0,
      scrollable: horizontalScrollableScrollableFinder,
    );

    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(ListCategory),
        matching: find.text('Favorite'),
      ),
    );

    await tester.pump();

    expect(find.byType(ProducthomeContainer), findsNWidgets(3));
  });
}
