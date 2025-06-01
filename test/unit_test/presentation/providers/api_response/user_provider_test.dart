import 'dart:async';

import 'package:fake_store/presentation/providers/api_response/user_provider.dart';
import 'package:fake_store_api_package/errors/index_errors.dart';
import 'package:fake_store_api_package/infraestructure/driven-adapter/api/auth_fake_store_api.dart';
import 'package:fake_store_api_package/infraestructure/driven-adapter/api/fake_store_api.dart';
import 'package:fake_store_api_package/infraestructure/helppers/mappers.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../mock/business_rules_mock.dart';
import '../mock/fake_mock.dart';
import 'user_provider_test.mocks.dart';

@GenerateMocks(
  [FakeStoreApi, AuthFakeStoreApi, ApiErrorHandler],
  customMocks: [
    MockSpec<FakeStoreApi>(as: #GeneratedMockFakeStoreApi),
    MockSpec<AuthFakeStoreApi>(as: #GeneratedMockAuthFakeStoreApi),
    MockSpec<ApiErrorHandler>(as: #GeneratedMockApiErrorHandler),
  ],
)
void main() {
  late ApiServices apiServices;
  late GeneratedMockFakeStoreApi mockFakeStoreApi;
  late GeneratedMockApiErrorHandler mockApiErrorHandler;
  late ProviderContainer container;

  group('UserNotifier Tests', () {
    setUp(() {
      mockFakeStoreApi = GeneratedMockFakeStoreApi();
      mockApiErrorHandler = GeneratedMockApiErrorHandler();
      apiServices = ApiServices(
        fakeStoreApi: mockFakeStoreApi,
        errorHandler: mockApiErrorHandler,
      );
      //Override provider with mock
      container = ProviderContainer(
        overrides: [
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, apiServices),
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('Return a users if success', () async {
      // Arrange

      when(
        mockFakeStoreApi.fetchUser('/users'),
      ).thenAnswer((_) async => FakeMock.userMock);

      //     Act
      await container
          .read(userInfoProvider.notifier)
          .fetchAllUsers('kingjames', 'goat23');

      final result = container.read(userInfoProvider);
      // Assert
      expect(result.isLoading, false);
      expect(result.errorMessage, isEmpty);
      expect(result.user?.username, 'kingjames');
    });

    test('Return error when API call fails (FAILURE case)', () async {
      // Arrange
      final expectedException = FetchFakeStoreException(
        message: 'API request failed',
        error: FetchFakeStoreError.notFound,
      );

      final expectedFailure = ApiFailure.fromException(expectedException);

      // Setup mock to throw an exception
      when(mockFakeStoreApi.fetchUser('/users')).thenThrow(expectedException);
      when(mockApiErrorHandler.handle(any)).thenReturn(expectedFailure);

      // Act
      await container
          .read(userInfoProvider.notifier)
          .fetchAllUsers('username', 'password');
      final state = container.read(userInfoProvider);
      // Assert
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, 'API request failed');
      expect(state.user, isNull);
    });

    test('Return no user when credentials do not match', () async {
      when(
        mockFakeStoreApi.fetchUser('/users'),
      ).thenAnswer((_) async => FakeMock.userMock);

      // Act
      await container
          .read(userInfoProvider.notifier)
          .fetchAllUsers('wronguser', 'wrongpass');

      final state = container.read(userInfoProvider);

      // Assert
      expect(state.isLoading, false);
      expect(state.errorMessage, equals('User not found'));
      expect(state.user, isNull);
    });

    test('LogOut user clears the user state', () {
      // Arrange - set initial user state
      container.read(userInfoProvider.notifier).state = container
          .read(userInfoProvider.notifier)
          .state
          .copyWith(user: BusinessRulesMock.mockUsers[1]);

      // Act
      container.read(userInfoProvider.notifier).logOutUser();

      // Assert
      final state = container.read(userInfoProvider);
      expect(state.user, isNull);
    });
    test('State shows loading during API call', () async {
      // Arrange
      final completer = Completer<List<UsersFakeStore>>();

      when(
        mockFakeStoreApi.fetchUser('/users'),
      ).thenAnswer((_) => completer.future);

      // Act
      final future = container
          .read(userInfoProvider.notifier)
          .fetchAllUsers('mj23', 'chicagoGOAT');

      // Assert
      expect(container.read(userInfoProvider).isLoading, isTrue);

      completer.complete(FakeMock.userMock);
      await future;

      // Assert
      expect(container.read(userInfoProvider).isLoading, isFalse);
    });
  });
}
