import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/presentation/pages.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_api_package/errors/structure/failure.dart';
import 'package:fake_store_api_package/infraestructure/helpers/mappers.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../unit_test/presentation/providers/mock/fake_mock.dart';
import 'login_screen_test.mocks.dart';

@GenerateMocks([ApiServices, KeyValueStorageService])
Widget buildWidget(ProviderContainer container) {
  final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: <RouteBase>[
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
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
  late MockApiServices mockApiServices;
  late MockKeyValueStorageService mockKeyValueStorage;

  group('LoginScreen', () {
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await AtomicDesignConfig.initializeFromAsset('assets/design/copys.json');
      await SemanticsConfig.initializeFromAsset(
        'assets/locale/en/semantics_json.json',
      );
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
        ],
      );
      addTearDown(container.dispose);
    });

    testWidgets("Find company logo", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final findImage = find.byType(AppAssetsImage);
      // Assert
      expect(findImage, findsOne);
    });

    testWidgets("Find text button", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      // Act
      final findButton = find.byType(TextButton);
      // Assert
      expect(findButton, findsOne);
    });

    testWidgets("Check input text", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildWidget(container));
      await tester.enterText(find.byKey(ValueKey("username")), 'allStoreHouse');
      await tester.enterText(find.byKey(ValueKey("password")), 'password');
      // Act
      final findUsername = find.text('allStoreHouse');
      final findPassword = find.text('password');
      // Assert
      expect(findUsername, findsOneWidget);
      expect(findPassword, findsOneWidget);
    });
    testWidgets("Calls fetchAuthentication when form is valid", (
      WidgetTester tester,
    ) async {
      // Arrange
      final expectedToken = FakeMock.tokenMock;
      await tester.pumpWidget(buildWidget(container));

      await tester.enterText(find.byKey(ValueKey("username")), 'john');
      await tester.enterText(find.byKey(ValueKey("password")), '1234');
      await tester.pump();

      when(
        mockApiServices.fetchAuth(username: 'john', password: '1234'),
      ).thenAnswer((_) async => Right(expectedToken));
      await tester.ensureVisible(find.byType(TextButton));
      await tester.tap(find.text('Enter'));
      await tester.pump(Duration.zero);

      // Act
      await container
          .read(authenticationProvider.notifier)
          .fetchAuthentication('john', '1234');
      final state = container.read(authenticationProvider);

      // Assert
      expect(
        state.token,
        equals('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mockTokenExample123'),
      );
    });

    testWidgets("Shows loading state during authentication", (
      WidgetTester tester,
    ) async {
      // Arrange
      final completer = Completer<Either<Failure, TokenFakeStore>>();

      when(
        mockApiServices.fetchAuth(username: 'kateh', password: 'kfejk@*'),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildWidget(container));
      await tester.enterText(find.byKey(ValueKey("username")), 'kateh');
      await tester.enterText(find.byKey(ValueKey("password")), 'kfejk@*');
      await tester.ensureVisible(find.text('Enter'));
      await tester.pumpAndSettle();

      // Act - submit form
      await tester.tap(
        find.text('Enter'),
        warnIfMissed: false,
      ); // Add warnIfMissed: false to suppress warning
      await tester.pump(Duration.zero); // This should trigger the loading state

      container
          .read(authenticationProvider.notifier)
          .fetchAuthentication('kateh', 'kfejk@*');

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete cleanup
      completer.complete(Right(TokenFakeStore.fromJson({'token': 'token'})));
      await tester.pump();
    });
  });
}
