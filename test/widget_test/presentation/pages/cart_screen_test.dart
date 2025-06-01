import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/presentation/pages/cart_screen.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../unit_test/presentation/providers/mock/business_rules_mock.dart';
import 'cart_screen_test.mocks.dart';

@GenerateMocks([ApiServices, KeyValueStorageService])
Widget buildWidget(ProviderContainer container) {
  final GoRouter router = GoRouter(
    initialLocation: '/cart',
    routes: <RouteBase>[
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(path: '/login', builder: (context, state) => const Scaffold()),
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
  late MockApiServices mockApiServices;
  late MockKeyValueStorageService mockKeyValueStorage;

  group('User Login', () {
    setUp(() {
      mockApiServices = MockApiServices();
      mockKeyValueStorage = MockKeyValueStorageService();
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(
            (ref) => AuthenticationNotifier(
                ref,
                mockKeyValueStorage,
                mockApiServices,
              )
              ..state = AuthenticationApiResponse(
                token: 'token',
                password: 'password',
                username: 'username',
              ),
          ),
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, mockApiServices)
              ..state = UserApiResponse(user: BusinessRulesMock.mockUsers[0]),
          ),
          cartListProvider.overrideWith(
            (ref) => CartListProvider()..state = BusinessRulesMock.mockProducts,
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    testWidgets("Find user name on screen", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final findUsername = find.text('John Doe');
      // Assert
      expect(findUsername, findsOneWidget);
    });

    testWidgets("Find the textbutton with the total to pay on the screen", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final findTextButton = find.text('Go To Pay : 296.46');
      // Assert
      expect(findTextButton, findsOne);
    });

    testWidgets(
      "Increase decreace the amount of elements when onPressedplus is tap",
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(container));
        for (var i = 0; i < 3; i++) {
          await tester.tap(
            find.descendant(
              of: find.byKey(ValueKey("ProductCartContainer-0")),
              matching: find.byIcon(AppIcons.plus),
            ),
          );
          await tester.pump();
        }

        // Act
        final firstAmount = find.descendant(
          of: find.byKey(ValueKey("ProductCartContainer-0")),
          matching: find.text('x4'),
        );
        // Assert
        expect(firstAmount, findsOneWidget);
        // Act
        for (var i = 0; i < 2; i++) {
          await tester.tap(
            find.descendant(
              of: find.byKey(ValueKey("ProductCartContainer-0")),
              matching: find.byIcon(AppIcons.minus),
            ),
          );
          await tester.pump();
        }
        final secondAmount = find.descendant(
          of: find.byKey(ValueKey("ProductCartContainer-0")),
          matching: find.text('x2'),
        );
        // Assert
        expect(secondAmount, findsOneWidget);
      },
    );

    testWidgets("should navigate to the product info", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(
        find.descendant(
          of: find.byKey(ValueKey("ProductCartContainer-0")),
          matching: find.byType(AppNetworkImage),
        ),
      );
      await tester.pumpAndSettle();
      // Assert
      expect(find.byType(CartTemplate), findsNothing);
    });

    testWidgets("Should find the las element of the products", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.scrollUntilVisible(
        find.descendant(
          of: find.byKey(ValueKey("ProductCartContainer-5")),
          matching: find.text('Smart LED Light Bulb'),
        ),
        100,
      );
      await tester.pump();
      // Act
      final findPrice = find.text('\$ 12.99');
      // Assert
      expect(findPrice, findsOneWidget);
    });

    testWidgets("should clean the cart and navigate to the homepage when buy", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      //Act
      final findIcon = find.byIcon(AppIcons.check);
      final amountOfProducts = container.read(cartListProvider);
      // Assert
      expect(amountOfProducts.length, equals(6));
      expect(findIcon, findsOneWidget);
      // Arrange
      await tester.tap(find.text('Continue Shopping'));
      await tester.pumpAndSettle();
      // Assert
      expect(find.byType(CartTemplate), findsNothing);
      expect(container.read(cartListProvider).length, equals(0));
    });

    testWidgets("should delete the user info on the screen", (
      WidgetTester tester,
    ) async {
      // Assert
      await tester.pumpWidget(buildWidget(container));
      when(mockKeyValueStorage.removeKey(any)).thenAnswer((_) async => true);
      await tester.tap(find.byIcon(AppIcons.logout));
      // Assert
      expect(container.read(authenticationProvider).token, equals(''));
    });
  });
  group('User Logout', () {
    setUp(() {
      mockApiServices = MockApiServices();
      mockKeyValueStorage = MockKeyValueStorageService();
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(
            (ref) => AuthenticationNotifier(
              ref,
              mockKeyValueStorage,
              mockApiServices,
            ),
          ),
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, mockApiServices),
          ),
          cartListProvider.overrideWith((ref) => CartListProvider()),
        ],
      );
      addTearDown(container.dispose);
    });
    testWidgets("LogIn should navigate to the loginscreen", (
      WidgetTester tester,
    ) async {
      // Assert
      await tester.pumpWidget(buildWidget(container));
      // Act
      await tester.tap(find.byIcon(AppIcons.login));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CartTemplate), findsNothing);
    });
    testWidgets("Empty cart should render Add Product", (
      WidgetTester tester,
    ) async {
      // Assert
      await tester.pumpWidget(buildWidget(container));
      // Act
      final findButtonText = find.text('Add Products');
      // Assert
      expect(findButtonText, findsOneWidget);
    });
    testWidgets(
      "should Render AppIcon.error because user not login and should navigate",
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(container));
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();
        // Act
        final findIconError = find.byIcon(AppIcons.error);
        // Assert
        expect(findIconError, findsOneWidget);
        // Arrange
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();
        // Assert
        expect(find.byType(CartTemplate), findsNothing);
      },
    );
  });
}
