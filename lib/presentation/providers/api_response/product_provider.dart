import 'dart:convert';

import 'package:fake_store/config/mock/special_categories.dart';
import 'package:fake_store/domain/models.dart';
import 'package:fake_store/domain/services/key_value_storage_service.dart';
import 'package:fake_store/infraestructure/helppers/mappers.dart';
import 'package:fake_store/infraestructure/services/key_value_storage.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsApiResponse {
  final bool isLoading; // Indicates whether the products are being loaded
  final String errorMessage; // Stores error message if something goes wrong
  final List<Product> allProducts; // The complete list of products retrieved
  final String selectedCategory; // The category selected for filtering products

  ProductsApiResponse({
    this.isLoading = false,
    this.errorMessage = '',
    this.allProducts = const [],
    this.selectedCategory = 'All',
  });

  // Allows partial updates to the current state
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

  // Returns the list of products filtered by the selected category
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
        // For any other category, return products that match it
        return allProducts
            .where((product) => product.category == selectedCategory)
            .toList();
    }
  }

  // Filters featured products by ID
  List<Product> _getSpecialFeaturedProducts(
    List<Product> products,
    List<int> productIds,
  ) {
    return products
        .where((product) => productIds.contains(product.id))
        .toList();
  }

  // Filters products that are on sale based on predefined IDs
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
  final KeyValueStorageService keyValueStorageService; // For local storage
  final ApiServices apiServices; // API service to fetch products

  // Initializes with default state and attempts to load products
  ProductsNotifier(this.keyValueStorageService, this.apiServices)
    : super(ProductsApiResponse()) {
    _initializeData();
  }

  // Loads products from local storage first; fetches from API if not found
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
    } catch (_) {
      // Ignore errors from shared preferences
    }

    // If still empty, load from the API
    if (state.allProducts.isEmpty) {
      await fetchAllProducts();
    }
  }

  // Calls the API to fetch products and updates the state accordingly
  Future<void> fetchAllProducts() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final productResult = await apiServices.fetchProducts();

      productResult.fold(
        // If failure: update error message
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        // If success: update state with products and store locally
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
            // Save the product list to local storage for offline access
            final jsonList =
                mappedProducts.map((product) => product.toJson()).toList();
            await keyValueStorageService.setKeyValue(
              'products',
              jsonEncode(jsonList),
            );
          } catch (_) {
            // Ignore local storage save errors
          }
        },
      );
    } catch (e) {
      // Unexpected exceptions
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  // Updates the selected category used to filter products
  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  // Clears any existing error messages in the state
  void clearError() {
    state = state.copyWith(errorMessage: '');
  }
}

// Provides the ProductsNotifier and its state to the app
final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsApiResponse>((ref) {
      final keyValueStore = KeyValueStorage(); // Dependency for local storage

      return ProductsNotifier(keyValueStore, ApiServices());
    });
