import 'package:fake_store/main.dart' as app;
import 'package:fake_store/presentation/pages.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("test description", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);

    // Find searchbar
    await tester.tap(find.text('Search Product'));
    await tester.pumpAndSettle();

    // Navigate to the product screen
    await tester.tapAt(const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(find.byType(ProductScreen), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.back));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
