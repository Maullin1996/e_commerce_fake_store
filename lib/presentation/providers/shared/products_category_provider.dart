import 'dart:convert';

import 'package:fake_store/config/mock/special_categories.dart';
import 'package:fake_store/infraestructure/services/key_value_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store/domain/models/product.dart';
import 'package:fake_store/presentation/providers/shared/favorite_list_provider.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final localProductsProvider = FutureProvider<List<Product>>((ref) async {
  final storage = KeyValueStorage();
  final jsonString = await storage.getValue<String>('products');

  if (jsonString == null) return [];

  final decoded = jsonDecode(jsonString) as List;

  return decoded.map((products) => Product.fromJson(products)).toList();
});

final productsByCategory = Provider<List<Product>>((ref) {
  final asyncProducts = ref.watch(localProductsProvider);

  return asyncProducts.when(
    data: (allProducts) {
      final category = ref.watch(selectedCategoryProvider);
      final favorites = ref.watch(myFavoriteListProvider);

      switch (category) {
        case 'All':
          return allProducts;
        case 'Favorite':
          return favorites;
        case 'Featured':
          return _specialFeaturedProducts(
            SpecialCategories.featured,
            allProducts,
          );
        case 'Sale Items':
          return _specialSaleItemsProducts(
            SpecialCategories.saleItems,
            allProducts,
          );
        default:
          return allProducts.where((p) => p.category == category).toList();
      }
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

List<Product> _specialFeaturedProducts(
  List<int> productIds,
  List<Product> products,
) {
  return products.where((product) => productIds.contains(product.id)).toList();
}

List<Product> _specialSaleItemsProducts(
  Map<int, double> productsId,
  List<Product> products,
) {
  if (products.isEmpty) return [];

  return products
      .where((element) => productsId.keys.contains(element.id))
      .toList();
}
