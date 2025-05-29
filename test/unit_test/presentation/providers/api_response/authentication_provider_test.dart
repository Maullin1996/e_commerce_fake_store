import 'dart:async';

import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_api_package/errors/index_errors.dart';
import 'package:fake_store_api_package/infraestructure/driven-adapter/index.dart';
import 'package:fake_store_api_package/infraestructure/helppers/mappers.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import '../mock/business_rules_mock_test.dart';
import '../mock/fake_mock_test.dart';
import 'authentication_provider_test.mocks.dart';

@GenerateMocks(
  [AuthFakeStoreApi, ApiErrorHandler, KeyValueStorageService],
  customMocks: [
    MockSpec<KeyValueStorageService>(as: #GeneratedMockKeyValue),
    MockSpec<AuthFakeStoreApi>(as: #GeneratedMockAuthFakeStoreApi),
    MockSpec<ApiErrorHandler>(as: #GeneratedMockApiErrorHandler),
  ],
)
void main() {
  late ApiServices apiServices;
  late GeneratedMockKeyValue mockKeyValueStorage;
  late GeneratedMockApiErrorHandler mockApiErrorHandler;
  late GeneratedMockAuthFakeStoreApi mockAuthFakeStoreApi;
  late ProviderContainer container;

  group('authenticationProvider Test', () {
    setUp(() {
      mockAuthFakeStoreApi = GeneratedMockAuthFakeStoreApi();
      mockApiErrorHandler = GeneratedMockApiErrorHandler();
      apiServices = ApiServices(
        authFakeStoreApi: mockAuthFakeStoreApi,
        errorHandler: mockApiErrorHandler,
      );
      mockKeyValueStorage = GeneratedMockKeyValue();
      //Override provider with mock
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(
            (ref) =>
                AuthenticationNotifier(ref, mockKeyValueStorage, apiServices),
          ),
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, apiServices)
              ..state = UserApiResponse(
                user: BusinessRulesMockTest.mockUsers[0],
              ),
          ),
          cartProvider.overrideWith(
            (ref) => CartNotifier(ref, apiServices)
              ..state = CartApiResponse(
                carts: BusinessRulesMockTest.mockCarts[0],
              ),
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('Return a Token if success', () async {
      // Arrange
      final expectedToken = FakeMockTest.tokenMock;

      when(
        mockAuthFakeStoreApi.authentication(
          username: 'kateh',
          password: 'kfejk@*',
        ),
      ).thenAnswer((_) async => expectedToken);

      // Act
      await container
          .read(authenticationProvider.notifier)
          .fetchAuthentication('kateh', 'kfejk@*');
      final state = container.read(authenticationProvider);

      // Assert
      expect(state.errorMessage, isEmpty);
      expect(state.token, equals(expectedToken.token));
    });
    test('Return error when API call fails (FAILURE case)', () async {
      // Arrange
      final expectedException = FetchFakeStoreException(
        message: 'API request failed',
        error: FetchFakeStoreError.notFound,
      );
      final expectedFailure = ApiFailure.fromException(expectedException);

      // Setup mock to throw an exception
      when(
        mockAuthFakeStoreApi.authentication(
          username: 'kateh',
          password: 'kfejk@*',
        ),
      ).thenThrow(expectedException);
      when(mockApiErrorHandler.handle(any)).thenReturn(expectedFailure);

      // Act
      await container
          .read(authenticationProvider.notifier)
          .fetchAuthentication('kateh', 'kfejk@*');
      final state = container.read(authenticationProvider);
      // Assert
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, 'API request failed');
      expect(state.token, isEmpty);
    });
    test('State shows loading during API call', () {
      // Arrange
      final completer = Completer<TokenFakeStore>();

      when(
        mockAuthFakeStoreApi.authentication(
          username: 'kateh',
          password: 'kfejk@*',
        ),
      ).thenAnswer((_) => completer.future);
      // Act
      container
          .read(authenticationProvider.notifier)
          .fetchAuthentication('kateh', 'kfejk@*');
      // Assert
      expect(container.read(authenticationProvider).isLoading, isTrue);
    });
    test('logOutUser resets state and clears storage', () {
      // Arrange
      when(mockKeyValueStorage.removeKey(any)).thenAnswer((_) async => true);

      // Set initial authenticated state
      container
          .read(authenticationProvider.notifier)
          .state = AuthenticationApiResponse(
        token: '123',
        username: 'kateh',
        password: 'kfejk@*',
      );

      // Act
      container.read(authenticationProvider.notifier).logOutUser();
      final state = container.read(authenticationProvider);

      // Assert
      expect(state.token, isEmpty);
      expect(state.username, isEmpty);
      expect(state.password, isEmpty);

      // Fixed verify call - remove the lambda function syntax
      verify(mockKeyValueStorage.removeKey('token')).called(1);
    });
    test('AuthenticationApiResponse copyWith returns modified object', () {
      final original = AuthenticationApiResponse(token: 'abc', isLoading: true);
      final updated = original.copyWith(token: 'xyz', isLoading: false);

      expect(updated.token, equals('xyz'));
      expect(updated.isLoading, isFalse);
      expect(updated.username, equals(''));
    });
  });
}
