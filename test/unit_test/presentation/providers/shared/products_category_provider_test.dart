import 'dart:convert';

import 'package:fake_store/domain/models/product.dart';
import 'package:fake_store/infraestructure/services/key_value_storage.dart';
import 'package:fake_store/presentation/providers/shared/favorite_list_provider.dart';
import 'package:fake_store/presentation/providers/shared/products_category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../mock/categories_mock.dart';
import 'products_category_provider_test.mocks.dart';

@GenerateMocks([KeyValueStorage])
void main() {
  late ProviderContainer container;
  late MockKeyValueStorage mockStorage;
  group('Providers Tests', () {
    setUp(() {
      mockStorage = MockKeyValueStorage();
    });
    tearDown(() {
      container.dispose();
    });
    group('selectedCategoryProvider', () {
      test('should have default value "All"', () {
        // Arrange
        container = ProviderContainer();

        // Act
        final category = container.read(selectedCategoryProvider);

        // Assert
        expect(category, equals('All'));
      });

      test('should update category when set', () {
        // Arrange
        container = ProviderContainer();

        // Act
        container.read(selectedCategoryProvider.notifier).state = 'Electronics';
        final category = container.read(selectedCategoryProvider);

        // Assert
        expect(category, equals('Electronics'));
      });
    });
    group('localProductsProvider', () {
      test('should return empty list when no data in storage', () async {
        // Arrange
        when(
          mockStorage.getValue<String>('products'),
        ).thenAnswer((_) async => null);

        container = ProviderContainer(
          overrides: [
            localProductsProvider.overrideWith((ref) async {
              final storage = mockStorage;
              final jsonString = await storage.getValue<String>('products');
              if (jsonString == null) return <Product>[];
              final decoded = jsonDecode(jsonString) as List;

              return decoded
                  .map((product) => Product.fromJson(product))
                  .toList();
            }),
          ],
        );

        // Act
        await container.read(localProductsProvider.future);
        final asyncValue = container.read(localProductsProvider);

        // Assert
        expect(asyncValue.hasValue, isTrue);
        expect(asyncValue.value, isEmpty);
        verify(mockStorage.getValue<String>('products')).called(1);
      });

      test('should return products when data exists in storage', () async {
        // Arrange
        final productsJson = jsonEncode(
          CategoriesMock.mockProducts.map((p) => p.toJson()).toList(),
        );
        when(
          mockStorage.getValue<String>('products'),
        ).thenAnswer((_) async => productsJson);

        container = ProviderContainer(
          overrides: [
            localProductsProvider.overrideWith((ref) async {
              final storage = mockStorage;
              final jsonString = await storage.getValue<String>('products');
              if (jsonString == null) return <Product>[];
              final decoded = jsonDecode(jsonString) as List;

              return decoded.map((e) => Product.fromJson(e)).toList();
            }),
          ],
        );

        // Act
        await container.read(localProductsProvider.future);
        final asycnValue = container.read(localProductsProvider);

        //Assert
        expect(asycnValue.value, hasLength(10));
        expect(
          asycnValue.value?.first.title,
          equals("Wireless Bluetooth Headphones"),
        );
        verify(mockStorage.getValue<String>('products')).called(1);
      });

      test('should handle JSON decode errors gracefully', () async {
        // Arrange
        when(
          mockStorage.getValue<String>('products'),
        ).thenAnswer((_) async => 'invalid-json');

        container = ProviderContainer(
          overrides: [
            localProductsProvider.overrideWith((ref) async {
              final storage = mockStorage;
              final jsonString = await storage.getValue<String>('products');
              if (jsonString == null) return <Product>[];
              try {
                final decoded = jsonDecode(jsonString) as List;

                return decoded
                    .map((product) => Product.fromJson(product))
                    .toList();
              } catch (error) {
                return <Product>[];
              }
            }),
          ],
        );

        // Act
        await container.read(localProductsProvider.future);
        final asycnValue = container.read(localProductsProvider);

        // Assert
        expect(asycnValue.value, isEmpty);
      });

      test('should handle loading state', () {
        // Arrange
        when(mockStorage.getValue<String>('products')).thenAnswer(
          (_) => Future.delayed(const Duration(milliseconds: 100), () => null),
        );

        container = ProviderContainer(
          overrides: [
            localProductsProvider.overrideWith((ref) async {
              final storage = mockStorage;
              final jsonString = await storage.getValue<String>('products');
              if (jsonString == null) return <Product>[];
              final decoded = jsonDecode(jsonString) as List;

              return decoded
                  .map((product) => Product.fromJson(product))
                  .toList();
            }),
          ],
        );

        // Act
        final asyncValue = container.read(localProductsProvider);

        // Assert
        expect(asyncValue.isLoading, isTrue);
        expect(asyncValue.hasValue, isFalse);
      });
    });

    group('group name', () {
      setUp(() {
        container = ProviderContainer(
          overrides: [
            localProductsProvider.overrideWith(
              (ref) => Future.value(CategoriesMock.mockProducts),
            ),
            myFavoriteListProvider.overrideWith(
              (ref) => FavoriteListProvider(CategoriesMock.mockFavorite),
            ),
          ],
        );
      });

      test('should return all products when category is "All"', () async {
        // Arrange
        container.read(selectedCategoryProvider.notifier).state = 'All';

        // Act
        await container.read(localProductsProvider.future);
        final products = container.read(productsByCategory);

        // Assert
        expect(products, hasLength(10));
        expect(products, equals(CategoriesMock.mockProducts));
      });

      test(
        'should return favorite products when category is "Favorite"',
        () async {
          // Arrange
          container.read(selectedCategoryProvider.notifier).state = 'Favorite';

          // Act
          await container.read(localProductsProvider.future);
          final products = container.read(productsByCategory);

          // Assert
          expect(products, hasLength(3));
          expect(products, equals(CategoriesMock.mockFavorite));
        },
      );

      test(
        'should return featured products when category is "Featured"',
        () async {
          // Arrange

          container = ProviderContainer(
            overrides: [
              localProductsProvider.overrideWith(
                (ref) => Future.value(CategoriesMock.mockProducts),
              ),
              myFavoriteListProvider.overrideWith(
                (ref) => FavoriteListProvider(CategoriesMock.mockFavorite),
              ),
            ],
          );

          container.read(selectedCategoryProvider.notifier).state = 'Featured';

          // Act
          await container.read(localProductsProvider.future);
          final products = container.read(productsByCategory);

          // Assert
          expect(products, hasLength(7)); // Todos los productos featured
          expect(
            products.map((product) => product.id),
            containsAll([3, 5, 6, 8, 4]),
          );
        },
      );

      test('should return sale items when category is "Sale Items"', () async {
        // Arrange
        container.read(selectedCategoryProvider.notifier).state = 'Sale Items';

        container = ProviderContainer(
          overrides: [
            localProductsProvider.overrideWith(
              (ref) => Future.value(CategoriesMock.mockProducts),
            ),
            myFavoriteListProvider.overrideWith(
              (ref) => FavoriteListProvider(CategoriesMock.mockFavorite),
            ),
          ],
        );

        container.read(selectedCategoryProvider.notifier).state = 'Sale Items';

        // Act
        await container.read(localProductsProvider.future);
        final products = container.read(productsByCategory);

        // Assert
        expect(products, hasLength(4));
        expect(products.map((product) => product.id), containsAll([1, 9]));
      });
    });
  });
}
