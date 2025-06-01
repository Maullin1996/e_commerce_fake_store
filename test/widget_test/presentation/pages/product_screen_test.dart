import 'package:fake_store/presentation/pages/product_screen.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_design/atoms/app_icons.dart';
import 'package:fake_store_design/template/tamplate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../unit_test/presentation/providers/mock/business_rules_mock.dart';

Widget buildWidget(ProviderContainer container) {
  final GoRouter router = GoRouter(
    initialLocation: '/product',
    routes: <RouteBase>[
      GoRoute(
        path: '/product',
        builder:
            (context, state) =>
                ProductScreen(product: BusinessRulesMock.mockProducts[4]),
      ),
      GoRoute(path: '/cart', builder: (context, state) => const Scaffold()),
      GoRoute(path: '/home', builder: (context, state) => const Scaffold()),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  late ProviderContainer container;

  group('ProductScreen', () {
    setUp(() {
      container = ProviderContainer(
        overrides: [
          myFavoriteListProvider.overrideWith(
            (ref) => FavoriteListProvider([]),
          ),
          cartListProvider.overrideWith((ref) => CartListProvider()),
        ],
      );
      addTearDown(container.dispose);
    });
    testWidgets("Find Icons on the screen", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final favortiteIcon = find.byIcon(AppIcons.unLike);
      final cartIcon = find.byIcon(AppIcons.cart);
      final backIcon = find.byIcon(AppIcons.back);
      // Assert
      expect(favortiteIcon, findsOneWidget);
      expect(cartIcon, findsOneWidget);
      expect(backIcon, findsOneWidget);
    });
    testWidgets("Find Text on the screen", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      await tester.scrollUntilVisible(find.byType(TextButton), 24.00);
      await tester.pump();
      final title = find.text('Yoga Mat with Carrying Strap');
      final description = find.text(
        'Enhance your yoga practice with this non-slip, comfortable yoga mat. Includes a convenient carrying strap for easy transport.',
      );
      final price = find.text("\$ 24.00");
      // Assert
      expect(title, findsOneWidget);
      expect(description, findsOneWidget);
      expect(price, findsOneWidget);
    });

    testWidgets("Add to the cart", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      await tester.scrollUntilVisible(find.byType(TextButton), 24.00);
      await tester.pump();
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      final state = container.read(cartListProvider);

      // Assert
      expect(state.length, equals(1));
      expect(state[0].price, equals(24.00));
    });

    testWidgets("Add to favorite", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      await tester.tap(find.byIcon(AppIcons.unLike));
      await tester.pump();
      final stateBefore = container.read(myFavoriteListProvider);
      // Assert
      expect(stateBefore.length, equals(1));
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final favortiteIcon = find.byIcon(AppIcons.favorite);
      expect(favortiteIcon, findsOneWidget);
    });
    testWidgets("Navigates to /cart after logout", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(find.byIcon(AppIcons.cart));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProductTemplate), findsNothing);
    });
  });
}
