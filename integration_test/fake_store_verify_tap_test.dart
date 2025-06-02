import 'package:fake_store/main.dart' as app;
import 'package:fake_store/presentation/pages.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Fake app verify Tap product", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    // Find a specifyc element
    final scrollables = find.byType(Scrollable).evaluate();
    final verticalScrollable = scrollables.firstWhere((element) {
      final scrollable = element.widget as Scrollable;

      return scrollable.axisDirection == AxisDirection.down;
    });

    final verticalScrollableFinder = find.byWidget(verticalScrollable.widget);

    await tester.scrollUntilVisible(
      find.byKey(ValueKey("ProductHome4")),
      300.0,
      scrollable: verticalScrollableFinder,
    );

    await tester.pumpAndSettle();

    // Navigate to the product screen
    await tester.tap(
      find.descendant(
        of: find.byKey(ValueKey("ProductHome4")),
        matching: find.byType(AppNetworkImage),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ProductScreen), findsOneWidget);

    // Find the button to add to the cart
    await tester.drag(find.byType(AppNetworkImage), const Offset(0, -200));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextButton));

    await tester.pumpAndSettle();

    // Navigate to the cart
    await tester.tap(find.byIcon(AppIcons.cart));
    await tester.pumpAndSettle();

    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.byType(ProductCartContainer), findsOneWidget);
  });
}
