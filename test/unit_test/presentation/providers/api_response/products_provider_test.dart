import 'dart:async';

import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/presentation/providers/api_response/products_provider.dart';
import 'package:fake_store_api_package/errors/handler/api_error_handler.dart';
import 'package:fake_store_api_package/errors/structure/api_failure.dart';
import 'package:fake_store_api_package/errors/structure/fetch_fake_store_exception.dart';
import 'package:fake_store_api_package/infraestructure/driven-adapter/api/fake_store_api.dart';
import 'package:fake_store_api_package/infraestructure/helppers/mappers.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../mock/fake_mock.dart';
import 'products_provider_test.mocks.dart';

@GenerateMocks(
  [FakeStoreApi, ApiErrorHandler, KeyValueStorageService],
  customMocks: [
    MockSpec<FakeStoreApi>(as: #GeneratedMockFakeStoreApi),
    MockSpec<ApiErrorHandler>(as: #GeneratedMockApiErrorHandler),
    MockSpec<KeyValueStorageService>(as: #GeneratedMockKeyValueStorage),
  ],
)
void main() {
  late ApiServices apiServices;
  late ProviderContainer container;
  late GeneratedMockFakeStoreApi mockFakeStoreApi;
  late GeneratedMockApiErrorHandler mockApiErrorHandler;
  late GeneratedMockKeyValueStorage mockKeyValueStorage;
  group('fetchAllProducts test', () {
    setUp(() {
      mockFakeStoreApi = GeneratedMockFakeStoreApi();
      mockApiErrorHandler = GeneratedMockApiErrorHandler();
      apiServices = ApiServices(
        fakeStoreApi: mockFakeStoreApi,
        errorHandler: mockApiErrorHandler,
      );
      mockKeyValueStorage = GeneratedMockKeyValueStorage();
      //Override provider with mock
      container = ProviderContainer(
        overrides: [
          productsProvider.overrideWith(
            (ref) => ProductNotifier(mockKeyValueStorage, apiServices),
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    test('Return a list of products if success', () async {
      // Arrange
      when(
        mockFakeStoreApi.fetchProducts('/products'),
      ).thenAnswer((_) async => FakeMock.productMock);

      when(mockKeyValueStorage.removeKey(any)).thenAnswer((_) async => true);

      // Act
      await container.read(productsProvider.notifier).fetchAllProducts();
      final state = container.read(productsProvider);

      // Assert
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isEmpty);
      expect(state.products, isNotNull);
      expect(state.products.length, equals(3));
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
        mockFakeStoreApi.fetchProducts('/products'),
      ).thenThrow(expectedException);
      when(mockApiErrorHandler.handle(any)).thenReturn(expectedFailure);
      when(mockKeyValueStorage.removeKey(any)).thenAnswer((_) async => true);
      // Act
      await container.read(productsProvider.notifier).fetchAllProducts();
      final state = container.read(productsProvider);

      // Assert
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, 'API request failed');
      expect(state.products, isEmpty);
    });

    test('State shows loading during API call', () async {
      // Arrange
      final completer = Completer<List<ProductsFakeStore>>();

      when(
        mockFakeStoreApi.fetchProducts('/products'),
      ).thenAnswer((_) => completer.future);
      when(mockKeyValueStorage.removeKey(any)).thenAnswer((_) async => true);

      // Act
      final future =
          container.read(productsProvider.notifier).fetchAllProducts();
      await Future.delayed(Duration.zero);

      //  Assert
      expect(container.read(productsProvider).isLoading, isTrue);

      completer.complete(FakeMock.productMock);
      await future;

      // Assert
      expect(container.read(productsProvider).isLoading, isFalse);
    });

    test('Guarda productos en almacenamiento local tras éxito', () async {
      // Arrange
      when(
        mockFakeStoreApi.fetchProducts('/products'),
      ).thenAnswer((_) async => FakeMock.productMock);
      when(mockKeyValueStorage.removeKey(any)).thenAnswer((_) async => true);
      when(
        mockKeyValueStorage.setKeyValue(any, any),
      ).thenAnswer((_) async => true);

      // Act
      await container.read(productsProvider.notifier).fetchAllProducts();

      // Assert
      verify(
        mockKeyValueStorage.setKeyValue(
          'products',
          isA<String>(), // podrías verificar contenido exacto si deseas
        ),
      ).called(1);
    });
  });
}
