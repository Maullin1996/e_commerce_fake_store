import 'package:fake_store/domain/models/product_entity.dart';
import 'package:fake_store/presentation/providers/api_response/products_provider.dart';
import 'package:fake_store/presentation/providers/shared/favorite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final productsByCategory = Provider<List<Product>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final allProducts = ref.watch(productsProvider).products;
  final favorites = ref.watch(myFavoriteListProvider);

  if (category == 'All') {
    return allProducts;
  } else if (category == 'favorite') {
    return favorites;
  } else {
    return allProducts
        .where((product) => product.category == category)
        .toList();
  }
});
