import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/presentation/pages/user_screen.dart';
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
import 'user_screen_test.mocks.dart';

@GenerateMocks([ApiServices, KeyValueStorageService])
Widget buildWidget(ProviderContainer container) {
  final GoRouter router = GoRouter(
    initialLocation: '/user',
    routes: <RouteBase>[
      GoRoute(path: '/user', builder: (context, state) => const UserScreen()),
      GoRoute(path: '/home', builder: (context, state) => const Scaffold()),
      GoRoute(
        path: '/cart',
        builder:
            (context, state) =>
                const Scaffold(body: Center(child: Icon(AppIcons.info))),
      ),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  late ProviderContainer container;
  late MockApiServices apiServices;
  late MockKeyValueStorageService mockKeyValueStorageService;

  group('UserScreen', () {
    apiServices = MockApiServices();
    mockKeyValueStorageService = MockKeyValueStorageService();
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await AtomicDesignConfig.initializeFromAsset('assets/design/copys.json');
      await SemanticsConfig.initializeFromAsset(
        'assets/locale/en/semantics_json.json',
      );
      container = ProviderContainer(
        overrides: [
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, apiServices)
              ..state = UserApiResponse(user: BusinessRulesMock.mockUsers[0]),
          ),
          authenticationProvider.overrideWith(
            (ref) => AuthenticationNotifier(
                ref,
                mockKeyValueStorageService,
                apiServices,
              )
              ..state = AuthenticationApiResponse(
                token: 'Token',
                password: BusinessRulesMock.mockUsers[0].password,
                username: BusinessRulesMock.mockUsers[0].username,
              ),
          ),
        ],
      );
      addTearDown(container.dispose);
    });
    testWidgets("Find the text on the screen", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final username = find.text('johndoe');
      final number = find.text('1-212-555-0123');
      final street = find.text('Broadway');
      final user = find.text('John Doe');
      // Assert
      expect(username, findsOneWidget);
      expect(number, findsOneWidget);
      expect(street, findsOneWidget);
      expect(user, findsOneWidget);
    });

    testWidgets("Find the icons on the screen", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final userIcon = find.byIcon(AppIcons.user);
      final emailIcon = find.byIcon(AppIcons.mail);
      final numberIcon = find.byIcon(AppIcons.direction);
      final logOutIcon = find.byIcon(AppIcons.logout);
      // Assert
      expect(userIcon, findsOneWidget);
      expect(emailIcon, findsOneWidget);
      expect(numberIcon, findsOneWidget);
      expect(logOutIcon, findsOneWidget);
    });

    testWidgets("Should delete user when tap on the button", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final stateBefore = container.read(authenticationProvider);
      // Assert
      expect(stateBefore.token, equals('Token'));
      expect(stateBefore.username, equals('johndoe'));

      // Arrange
      when(
        mockKeyValueStorageService.removeKey(any),
      ).thenAnswer((_) async => true);
      await tester.tap(find.byIcon(AppIcons.logout));
      await tester.pump();
      // Act
      container.read(authenticationProvider.notifier).logOutUser();
      final stateAfter = container.read(authenticationProvider);
      expect(stateAfter.token, equals(''));
      expect(stateAfter.username, equals(''));
      verify(mockKeyValueStorageService.removeKey('token')).called(2);
    });
    testWidgets("Navigates to /home after logout", (tester) async {
      when(
        mockKeyValueStorageService.removeKey(any),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(buildWidget(container));
      await tester.tap(find.byIcon(AppIcons.logout));
      await tester.pumpAndSettle();

      expect(find.byType(UserTemplate), findsNothing);
    });
    testWidgets("Navigates to /cart when cart button is tapped", (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(container));
      await tester.tap(find.byIcon(AppIcons.cart));
      await tester.pumpAndSettle();
      expect(find.byIcon(AppIcons.info), findsOneWidget);
    });
  });

  group('user == null and loading = True', () {
    apiServices = MockApiServices();
    mockKeyValueStorageService = MockKeyValueStorageService();
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await AtomicDesignConfig.initializeFromAsset('assets/design/copys.json');
      await SemanticsConfig.initializeFromAsset(
        'assets/locale/en/semantics_json.json',
      );
      container = ProviderContainer(
        overrides: [
          userInfoProvider.overrideWith(
            (ref) =>
                UserNotifier(ref, apiServices)
                  ..state = UserApiResponse(user: null, isLoading: true),
          ),
          authenticationProvider.overrideWith(
            (ref) => AuthenticationNotifier(
                ref,
                mockKeyValueStorageService,
                apiServices,
              )
              ..state = AuthenticationApiResponse(
                token: 'Token',
                password: BusinessRulesMock.mockUsers[0].password,
                username: BusinessRulesMock.mockUsers[0].username,
              ),
          ),
        ],
      );
      addTearDown(container.dispose);
    });
    testWidgets("should render a CircularProgressIndicator()", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final circularProgress = find.byType(CircularProgressIndicator);
      // Assert
      expect(circularProgress, findsOne);
    });
  });
}
