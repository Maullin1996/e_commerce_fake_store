import 'dart:async';

import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_api_package/errors/index_errors.dart';
import 'package:fake_store_api_package/infraestructure/driven-adapter/api/fake_store_api.dart';
import 'package:fake_store_api_package/infraestructure/helppers/mappers.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import '../mock/business_rules_mock_test.dart';
import '../mock/fake_mock_test.dart';
import 'user_provider_test.mocks.dart';

@GenerateMocks(
  [FakeStoreApi, ApiErrorHandler],
  customMocks: [
    MockSpec<FakeStoreApi>(as: #GeneratedMockFakeStoreApi),
    MockSpec<ApiErrorHandler>(as: #GeneratedMockApiErrorHandler),
  ],
)
void main() {
  late ApiServices apiServices;
  late GeneratedMockFakeStoreApi mockFakeStoreApi;
  late GeneratedMockApiErrorHandler mockApiErrorHandler;
  late ProviderContainer container;

  group('CartNotifier Tests', () {
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
          cartProvider.overrideWith((ref) => CartNotifier(ref, apiServices)),
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, apiServices)
              ..state = UserApiResponse(
                user: BusinessRulesMockTest.mockUsers[0],
              ),
          ),
          localProductsProvider.overrideWith(
            (ref) async => BusinessRulesMockTest.mockProducts,
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('Return a cart with their products if success', () async {
      // Arrange
      when(
        mockFakeStoreApi.fetchCart('/carts'),
      ).thenAnswer((_) async => FakeMockTest.cartMock);

      // Act
      await container.read(cartProvider.notifier).fetchAllCarts();
      final state = container.read(cartProvider);

      // Assert
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isEmpty);
      expect(state.carts, isNotNull);
      expect(state.carts!.products.length, equals(3));
    });

    test('Return error when API call fails (FAILURE case)', () async {
      // Arrange
      final expectedException = FetchFakeStoreException(
        message: 'API request failed',
        error: FetchFakeStoreError.notFound,
      );
      final expectedFailure = ApiFailure.fromException(expectedException);

      // Setup mock to throw an exception
      when(mockFakeStoreApi.fetchCart('/carts')).thenThrow(expectedException);
      when(mockApiErrorHandler.handle(any)).thenReturn(expectedFailure);

      // Act
      await container.read(cartProvider.notifier).fetchAllCarts();
      final state = container.read(cartProvider);
      // Assert
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, 'API request failed');
      expect(state.carts, isNull);
    });
    test('State shows loading during API call', () async {
      // Arrange
      final completer = Completer<List<CartsFakeStore>>();

      when(
        mockFakeStoreApi.fetchCart('/carts'),
      ).thenAnswer((_) => completer.future);

      // Act
      final future = container.read(cartProvider.notifier).fetchAllCarts();
      await Future.delayed(Duration.zero);
      // Assert
      expect(container.read(cartProvider).isLoading, isTrue);

      completer.complete(FakeMockTest.cartMock);
      await future;

      // Assert
      expect(container.read(cartProvider).isLoading, isFalse);
    });

    test('deleteUserCart clears the user cart', () {
      container.read(cartProvider.notifier).state = container
          .read(cartProvider.notifier)
          .state
          .copyWith(carts: BusinessRulesMockTest.mockCarts[0]);

      // Act
      container.read(cartProvider.notifier).deleteUserCart();
      final state = container.read(cartProvider).carts;

      // Assert
      expect(state, isNull);
    });

    test('deleteUserCart handles null cart state', () {
      // Arrange
      container.read(cartProvider.notifier).state = container
          .read(cartProvider.notifier)
          .state
          .copyWith(carts: null);
      // Assert
      expect(
        () => container.read(cartProvider.notifier).deleteUserCart(),
        returnsNormally,
      );

      final state = container.read(cartProvider).carts;
      expect(state, isNull);
    });
  });

  group('User not found', () {
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
          cartProvider.overrideWith((ref) => CartNotifier(ref, apiServices)),
          userInfoProvider.overrideWith(
            (ref) =>
                UserNotifier(ref, apiServices)
                  ..state = UserApiResponse(user: null),
          ),
          localProductsProvider.overrideWith(
            (ref) async => BusinessRulesMockTest.mockProducts,
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('fetchAllCarts handles user not found scenario', () async {
      // Arrange
      when(
        mockFakeStoreApi.fetchCart('/carts'),
      ).thenAnswer((_) async => FakeMockTest.cartMock);
      //  Act
      await container.read(cartProvider.notifier).fetchAllCarts();
      final state = container.read(cartProvider);

      //Assert
      expect(state.carts, isNull);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, 'User Not Found');
    });
  });

  group('Empty Cart List', () {
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
          cartProvider.overrideWith((ref) => CartNotifier(ref, apiServices)),
          userInfoProvider.overrideWith(
            (ref) => UserNotifier(ref, apiServices)
              ..state = UserApiResponse(
                user: BusinessRulesMockTest.mockUsers[2],
              ),
          ),
          localProductsProvider.overrideWith(
            (ref) async => BusinessRulesMockTest.mockProducts,
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('fetchAllCarts handles user not found scenario', () async {
      // Arrange
      when(
        mockFakeStoreApi.fetchCart('/carts'),
      ).thenAnswer((_) async => FakeMockTest.cartMock);
      //  Act
      await container.read(cartProvider.notifier).fetchAllCarts();
      final state = container.read(cartProvider);

      //Assert
      expect(state.carts, isNotNull);
      expect(state.isLoading, isFalse);
      expect(state.carts?.products, isEmpty);
    });
  });
}
