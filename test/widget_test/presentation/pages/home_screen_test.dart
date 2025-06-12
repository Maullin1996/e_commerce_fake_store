import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/presentation/pages/home_screen.dart';
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
import '../../../unit_test/presentation/providers/mock/categories_mock.dart';
import 'home_screen_test.mocks.dart';

@GenerateMocks([ApiServices, KeyValueStorageService])
Widget buildWidget(ProviderContainer container) {
  final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/product', builder: (context, state) => const Scaffold()),
      GoRoute(path: '/login', builder: (context, state) => const Scaffold()),
      GoRoute(path: '/user', builder: (context, state) => const Scaffold()),
      GoRoute(path: '/cart', builder: (context, state) => const Scaffold()),
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

  group('HomeScreen user login', () {
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await AtomicDesignConfig.initializeFromAsset('assets/design/copys.json');
      await SemanticsConfig.initializeFromAsset(
        'assets/locale/en/semantics_json.json',
      );
      mockApiServices = MockApiServices();
      mockKeyValueStorage = MockKeyValueStorageService();

      when(
        mockKeyValueStorage.getValue<String>('products'),
      ).thenAnswer((_) async => null);
      when(
        mockKeyValueStorage.setKeyValue(any, any),
      ).thenAnswer((_) async => true);
      when(mockKeyValueStorage.removeKey(any)).thenAnswer((_) async => true);

      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(
            (ref) => AuthenticationNotifier(
                ref,
                mockKeyValueStorage,
                mockApiServices,
              )
              ..state = AuthenticationApiResponse(
                token: 'Token',
                username: 'usermane',
                password: 'password',
              ),
          ),
          myFavoriteListProvider.overrideWith(
            (ref) => FavoriteListProvider(CategoriesMock.mockFavorite),
          ),
          cartListProvider.overrideWith((ref) => CartListProvider()),
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, mockApiServices)
              ..state = UserApiResponse(user: BusinessRulesMock.mockUsers[0]),
          ),
          productsProvider.overrideWith(
            (ref) => ProductsNotifier(mockKeyValueStorage, mockApiServices)
              ..state = ProductsApiResponse(
                allProducts: CategoriesMock.mockProducts,
              ),
          ),
        ],
      );
      addTearDown(container.dispose);
    });
    testWidgets("test description", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final findUsername = find.text('John Doe');
      final findCategory = find.text('Featured');
      // Assert
      expect(findUsername, findsOneWidget);
      expect(findCategory, findsOneWidget);
    });
    testWidgets("Should navigate to userscreen", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(find.byIcon(AppIcons.user));
      await tester.pumpAndSettle();
      // Assert
      expect(find.byType(HomeTemplate), findsNothing);
    });
    testWidgets("Should navigate to cartscreen", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(find.byIcon(AppIcons.cart));
      await tester.pumpAndSettle();
      // Assert
      expect(find.byType(HomeTemplate), findsNothing);
    });
    testWidgets("Should delete user info", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(find.byIcon(AppIcons.logout));
      await tester.pump();
      //Act
      final findHomeText = find.text('Home');
      // Assert
      expect(findHomeText, findsWidgets);
    });
    testWidgets("should Navigate to the product screen", (
      WidgetTester tester,
    ) async {
      //Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(
        find.descendant(
          of: find.byKey(ValueKey("ProductHome1")),
          matching: find.byType(AppNetworkImage),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HomeTemplate), findsNothing);
    });
    testWidgets("should find products without scrolling", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));

      // Act
      final allProducts = find.byType(ProducthomeContainer);
      final firstProduct = find.byKey(ValueKey("ProductHome1"));

      // Assert
      expect(allProducts, findsWidgets);
      expect(firstProduct, findsOneWidget);
    });
    testWidgets("should update the favorite icon", (WidgetTester tester) async {
      //Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(
        find.descendant(
          of: find.byKey(ValueKey("ProductHome1")),
          matching: find.byIcon(AppIcons.unLike),
        ),
      );
      await tester.pump();

      // Act
      final iconFavorite = find.byIcon(AppIcons.favorite);
      // Assert
      expect(iconFavorite, findsOneWidget);
    });
    testWidgets("Scroll until find the element and tap add to cart", (
      WidgetTester tester,
    ) async {
      //Arrange - Before tap
      await tester.pumpWidget(buildWidget(container));
      // Assert
      expect(container.read(cartListProvider).length, equals(0));

      final scrollables = find.byType(Scrollable).evaluate();
      final verticalScrollable = scrollables.firstWhere((element) {
        final scrollable = element.widget as Scrollable;

        return scrollable.axisDirection == AxisDirection.down;
      });
      //Arrange - After tap
      final verticalScrollableFinder = find.byWidget(verticalScrollable.widget);

      await tester.scrollUntilVisible(
        find.byKey(ValueKey("ProductHome4")),
        300.0,
        scrollable: verticalScrollableFinder,
      );

      await tester.pump();

      await tester.tap(
        find.descendant(
          of: find.byKey(ValueKey("ProductHome4")),
          matching: find.byType(TextButton),
        ),
      );
      // Assert
      expect(container.read(cartListProvider).length, equals(1));
    });

    testWidgets("should open the search bar when tap", (
      WidgetTester tester,
    ) async {
      //Arrange - Before tap
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(find.text('Search Product'), warnIfMissed: false);
      await tester.pump();
      // Act
      final findProduct = find.text('Wireless Bluetooth Headphones');
      // Assert
      expect(findProduct, findsOneWidget);
    });

    testWidgets("should change between the categories", (
      WidgetTester tester,
    ) async {
      //Arrange - Before tap
      await tester.pumpWidget(buildWidget(container));

      final scrollables = find.byType(Scrollable).evaluate();
      final verticalScrollable = scrollables.firstWhere((element) {
        final scrollable = element.widget as Scrollable;

        return scrollable.axisDirection == AxisDirection.right;
      });
      final verticalScrollableFinder = find.byWidget(verticalScrollable.widget);

      await tester.scrollUntilVisible(
        find.descendant(
          of: find.byType(ListCategory),
          matching: find.text('Favorite'),
        ),
        300.0,
        scrollable: verticalScrollableFinder,
      );

      await tester.tap(find.text('Favorite'));
      await tester.pump();

      // Act
      final findTitleProduct = find.text("Men's Slim Fit Jeans");

      // Assert
      expect(findTitleProduct, findsOneWidget);
    });
  });
  group('Api  Response error message', () {
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await AtomicDesignConfig.initializeFromAsset('assets/design/copys.json');
      mockApiServices = MockApiServices();
      mockKeyValueStorage = MockKeyValueStorageService();

      when(
        mockKeyValueStorage.getValue<String>('products'),
      ).thenAnswer((_) async => null);
      when(
        mockKeyValueStorage.setKeyValue(any, any),
      ).thenAnswer((_) async => true);
      when(mockKeyValueStorage.removeKey(any)).thenAnswer((_) async => true);

      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(
            (ref) => AuthenticationNotifier(
                ref,
                mockKeyValueStorage,
                mockApiServices,
              )
              ..state = AuthenticationApiResponse(
                token: 'Token',
                username: 'usermane',
                password: 'password',
              ),
          ),
          myFavoriteListProvider.overrideWith(
            (ref) => FavoriteListProvider([]),
          ),
          cartListProvider.overrideWith((ref) => CartListProvider()),
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, mockApiServices)
              ..state = UserApiResponse(user: BusinessRulesMock.mockUsers[0]),
          ),
          productsProvider.overrideWith(
            (ref) => ProductsNotifier(mockKeyValueStorage, mockApiServices)
              ..state = ProductsApiResponse(
                allProducts: [],
                errorMessage: 'error',
              ),
          ),
        ],
      );
      addTearDown(container.dispose);
    });
    testWidgets("should show the error message", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final findText = find.text('Error to get the products');
      // Assert
      expect(findText, findsOneWidget);
    });
  });

  group('Api  Response error message', () {
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await AtomicDesignConfig.initializeFromAsset('assets/design/copys.json');
      mockApiServices = MockApiServices();
      mockKeyValueStorage = MockKeyValueStorageService();

      when(
        mockKeyValueStorage.getValue<String>('products'),
      ).thenAnswer((_) async => null);
      when(
        mockKeyValueStorage.setKeyValue(any, any),
      ).thenAnswer((_) async => true);
      when(mockKeyValueStorage.removeKey(any)).thenAnswer((_) async => true);

      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(
            (ref) => AuthenticationNotifier(
                ref,
                mockKeyValueStorage,
                mockApiServices,
              )
              ..state = AuthenticationApiResponse(
                token: 'Token',
                username: 'usermane',
                password: 'password',
              ),
          ),
          myFavoriteListProvider.overrideWith(
            (ref) => FavoriteListProvider([]),
          ),
          cartListProvider.overrideWith((ref) => CartListProvider()),
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, mockApiServices)
              ..state = UserApiResponse(user: BusinessRulesMock.mockUsers[0]),
          ),
          productsProvider.overrideWith(
            (ref) => ProductsNotifier(mockKeyValueStorage, mockApiServices)
              ..state = ProductsApiResponse(allProducts: [], isLoading: true),
          ),
        ],
      );
      addTearDown(container.dispose);
    });
    testWidgets("should render skeleton Loading", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final findWidget = find.byType(SkeletonLoadingContainer);
      // Assert
      expect(findWidget, findsWidgets);
    });
  });
}
