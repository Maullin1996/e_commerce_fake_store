import 'package:fake_store/main.dart' as app;
import 'package:fake_store/presentation/pages.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Should navigate to the productscreen from the cartscreen", (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    // add product to the cart
    await tester.tap(
      find.descendant(
        of: find.byKey(ValueKey("ProductHome1")),
        matching: find.byType(TextButton),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to the cartscreen
    await tester.tap(find.byIcon(AppIcons.cart));
    await tester.pumpAndSettle();

    expect(find.byType(CartScreen), findsOneWidget);

    // Navigate to the productscreen
    await tester.tap(
      find.descendant(
        of: find.byType(ProductCartContainer),
        matching: find.byType(AppNetworkImage),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ProductScreen), findsOneWidget);
  });
}
