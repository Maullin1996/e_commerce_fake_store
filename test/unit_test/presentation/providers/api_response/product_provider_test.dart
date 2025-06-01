import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_api_package/errors/index_errors.dart';
import 'package:fake_store_api_package/errors/structure/failure.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../mock/business_rules_mock.dart';
import '../mock/fake_mock.dart';
import 'product_provider_test.mocks.dart';

@GenerateMocks([ApiServices, KeyValueStorageService])
void main() {
  late MockApiServices mockApiServices;
  late MockKeyValueStorageService mockKeyValueStorage;
  late ProviderContainer container;
  group('ProductsNotifier Tests', () {
    setUp(() {
      mockApiServices = MockApiServices();
      mockKeyValueStorage = MockKeyValueStorageService();
      container = ProviderContainer(
        overrides: [
          productsProvider.overrideWith(
            (ref) => ProductsNotifier(mockKeyValueStorage, mockApiServices),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('Initialization', () {
      test('should initialize with default state', () {
        // Arrange - Mock the storage to return null (no cached data)
        when(
          mockKeyValueStorage.getValue<String>('products'),
        ).thenAnswer((_) async => null);
        // Mock the API call that will be triggered during initialization
        when(
          mockApiServices.fetchProducts(),
        ).thenAnswer((_) async => Right([]));
        when(
          mockKeyValueStorage.setKeyValue(any, any),
        ).thenAnswer((_) async => {});

        // Act
        final notifier = ProductsNotifier(mockKeyValueStorage, mockApiServices);

        // Assert initial state immediately (before async initialization completes)
        expect(notifier.state.isLoading, false);
        expect(notifier.state.errorMessage, '');
        expect(notifier.state.allProducts, isEmpty);
        expect(notifier.state.selectedCategory, 'All');
      });
      test(
        'should load products from storage on initialization if available',
        () async {
          final jsonString = jsonEncode(BusinessRulesMock.mockProducts);

          when(
            mockKeyValueStorage.getValue<String>('products'),
          ).thenAnswer((_) async => jsonString);

          // Act
          final notifier = ProductsNotifier(
            mockKeyValueStorage,
            mockApiServices,
          );
          await Future.delayed(
            Duration.zero,
          ); // Allow async initialization to complete

          // Assert
          verify(mockKeyValueStorage.getValue<String>('products')).called(1);
          expect(notifier.state.allProducts.length, 6);
        },
      );
      test('should fetch products from API if storage is empty', () async {
        // Arrange
        when(
          mockKeyValueStorage.getValue<String>('products'),
        ).thenAnswer((_) async => null);
        when(
          mockApiServices.fetchProducts(),
        ).thenAnswer((_) async => Right(FakeMock.productMock));

        // Act
        final notifier = ProductsNotifier(mockKeyValueStorage, mockApiServices);
        await Future.delayed(Duration.zero);

        // Assert
        verify(mockApiServices.fetchProducts()).called(1);
      });
    });
    group('fetchAllProducts', () {
      test('should set loading state when fetching products', () async {
        // Arrange
        when(
          mockApiServices.fetchProducts(),
        ).thenAnswer((_) async => Right([]));

        // Act
        final notifier = container.read(productsProvider.notifier);
        final fetchFuture = notifier.fetchAllProducts();

        // Assert loading state
        expect(container.read(productsProvider).isLoading, true);

        await fetchFuture;
      });

      test('should update state with products on successful fetch', () async {
        // Arrange

        when(
          mockApiServices.fetchProducts(),
        ).thenAnswer((_) async => Right(FakeMock.productMock));
        when(
          mockKeyValueStorage.setKeyValue(any, any),
        ).thenAnswer((_) async => {});

        // Act
        await container.read(productsProvider.notifier).fetchAllProducts();

        // Assert
        final state = container.read(productsProvider);
        expect(state.isLoading, false);
        expect(state.errorMessage, '');
        expect(state.allProducts.length, equals(3));

        // Verify storage was called
        verify(mockKeyValueStorage.setKeyValue('products', any)).called(2);
      });
      test('should handle API failure correctly', () async {
        // Arrange
        final failure = ApiFailure(
          message: 'Network error',
          error: FetchFakeStoreError.notFound,
        );
        when(
          mockApiServices.fetchProducts(),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final notifier = container.read(productsProvider.notifier);
        await notifier.fetchAllProducts();

        // Assert
        final state = container.read(productsProvider);
        expect(state.isLoading, false);
        expect(state.errorMessage, 'Network error');
        expect(state.allProducts, isEmpty);
      });

      test('should handle unexpected errors', () async {
        // Arrange
        when(
          mockApiServices.fetchProducts(),
        ).thenThrow(Exception('Unexpected error'));

        // Act
        final notifier = container.read(productsProvider.notifier);
        await notifier.fetchAllProducts();

        // Assert
        final state = container.read(productsProvider);
        expect(state.isLoading, false);
        expect(state.errorMessage, startsWith('Error inespetado:'));
      });
    });

    group('setCategory', () {
      test('should update selected category', () {
        // Act
        final notifier = container.read(productsProvider.notifier);
        notifier.setCategory('electronics');

        // Assert
        expect(
          container.read(productsProvider).selectedCategory,
          'electronics',
        );
      });
    });
  });
}
