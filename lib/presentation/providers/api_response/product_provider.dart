import 'dart:convert';

import 'package:fake_store/config/mock/special_categories.dart';
import 'package:fake_store/domain/models.dart';
import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/infraestructure/helppers/mappers.dart';
import 'package:fake_store/infraestructure/services/key_value_storage.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsApiResponse {
  final bool isLoading;
  final String errorMessage;
  final List<Product> allProducts;
  final String selectedCategory;

  ProductsApiResponse({
    this.isLoading = false,
    this.errorMessage = '',
    this.allProducts = const [],
    this.selectedCategory = 'All',
  });

  ProductsApiResponse copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Product>? allProducts,
    String? selectedCategory,
  }) {
    return ProductsApiResponse(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      allProducts: allProducts ?? this.allProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  List<Product> get filteredProducts {
    switch (selectedCategory) {
      case 'All':
        return allProducts;
      case 'Featured':
        return _getSpecialFeaturedProducts(
          allProducts,
          SpecialCategories.featured,
        );
      case 'Sale Items':
        return _getSpecialSaleItemsProducts(
          SpecialCategories.saleItems,
          allProducts,
        );
      default:
        return allProducts
            .where((product) => product.category == selectedCategory)
            .toList();
    }
  }

  List<Product> _getSpecialFeaturedProducts(
    List<Product> products,
    List<int> productIds,
  ) {
    return products
        .where((product) => productIds.contains(product.id))
        .toList();
  }

  List<Product> _getSpecialSaleItemsProducts(
    Map<int, double> productsId,
    List<Product> products,
  ) {
    if (products.isEmpty) return [];

    return products
        .where((element) => productsId.keys.contains(element.id))
        .toList();
  }
}

class ProductsNotifier extends StateNotifier<ProductsApiResponse> {
  final KeyValueStorageService keyValueStorageService;
  final ApiServices apiServices;

  ProductsNotifier(this.keyValueStorageService, this.apiServices)
    : super(ProductsApiResponse()) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final jsonString = await keyValueStorageService.getValue<String>(
        'products',
      );
      if (jsonString != null && jsonString.isNotEmpty) {
        final decoded = jsonDecode(jsonString) as List;
        final products = decoded.map((item) => Product.fromJson(item)).toList();

        if (products.isNotEmpty) {
          state = state.copyWith(allProducts: products);
        }
      }
    } catch (_) {}
    if (state.allProducts.isEmpty) {
      await fetchAllProducts();
    }
  }

  Future<void> fetchAllProducts() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final productResult = await apiServices.fetchProducts();

      productResult.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (products) async {
          final mappedProducts =
              products
                  .map(
                    (product) =>
                        ProductMapper.productFakeStoreToProduct(product),
                  )
                  .toList();
          state = state.copyWith(
            allProducts: mappedProducts,
            isLoading: false,
            errorMessage: '',
          );

          try {
            final jsonList =
                mappedProducts.map((product) => product.toJson()).toList();
            await keyValueStorageService.setKeyValue(
              'products',
              jsonEncode(jsonList),
            );
          } catch (_) {}
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error inespetado: $e',
      );
    }
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void clearError() {
    state = state.copyWith(errorMessage: '');
  }
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsApiResponse>((ref) {
      final keyValueStore = KeyValueStorage();

      return ProductsNotifier(keyValueStore, ApiServices());
    });
