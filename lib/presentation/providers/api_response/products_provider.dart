import 'dart:convert';

import 'package:fake_store/domain/models/product.dart';
import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/infraestructure/helppers/products/product_mapper.dart';
import 'package:fake_store/infraestructure/services/key_value_storage.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductApiResponse {
  final bool isLoading;
  final String errorMessage;
  final String category;
  final List<Product> products;

  ProductApiResponse({
    this.isLoading = false,
    this.errorMessage = '',
    this.category = 'All',
    this.products = const [],
  });

  ProductApiResponse copyWith({
    bool? isLoading,
    String? errorMessage,
    String? category,
    List<Product>? products,
  }) {
    return ProductApiResponse(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      category: category ?? this.category,
      products: products ?? this.products,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductApiResponse> {
  ProductNotifier(this.keyValueStorageService) : super(ProductApiResponse());

  final KeyValueStorageService keyValueStorageService;
  final ApiServices _apiServices = ApiServices();

  Future<void> fetchAllProducts() async {
    await _fetchByCategory(null);
  }

  Future<void> fetchByCategory(String? categoryPath) async {
    await _fetchByCategory(categoryPath);
  }

  Future<void> _fetchByCategory(String? categoryPath) async {
    await keyValueStorageService.removeKey('products');
    state = state.copyWith(
      isLoading: true,
      errorMessage: '',
      category: categoryPath ?? 'All',
      products: const [],
    );

    final productResult = await _apiServices.fetchProducts(
      category: categoryPath,
    );

    productResult.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          products: const [],
        );
      },
      (products) async {
        state = state.copyWith(
          products:
              products
                  .map(
                    (product) =>
                        ProductMapper.productFakeStoreToProduct(product),
                  )
                  .toList(),
          isLoading: false,
          errorMessage: '',
        );
        final jsonList =
            state.products.map((product) => product.toJson()).toList();
        await keyValueStorageService.setKeyValue(
          'products',
          jsonEncode(jsonList),
        );
      },
    );
  }
}

final productsProvider =
    StateNotifierProvider<ProductNotifier, ProductApiResponse>((ref) {
      final keyValueStorage = KeyValueStorage();

      return ProductNotifier(keyValueStorage);
    });
