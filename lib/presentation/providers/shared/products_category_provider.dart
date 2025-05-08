import 'package:fake_store/config/mock/special_categories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store/domain/models/product.dart';
import 'package:fake_store/presentation/providers/api_response/products_provider.dart';
import 'package:fake_store/presentation/providers/shared/favorite_list_provider.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final productsByCategory = Provider<List<Product>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final allProducts = ref.watch(productsProvider).products;
  final favorites = ref.watch(myFavoriteListProvider);

  switch (category) {
    case 'All':
      return allProducts;
    case 'Favorite':
      return favorites;
    case 'Featured':
      return _specialFeaturedProducts(SpecialCategories.featured, allProducts);
    case 'Sale Items':
      return _specialSaleItemsProducts(
        SpecialCategories.saleItems,
        allProducts,
      );
    default:
      return allProducts
          .where((product) => product.category == category)
          .toList();
  }
});

List<Product> _specialFeaturedProducts(
  List<int> productsId,
  List<Product> products,
) {
  List<Product> newProductList = [];
  if (products.isEmpty) return [];
  for (int index in productsId) {
    newProductList.add(products[index - 1]);
  }

  return newProductList;
}

List<Product> _specialSaleItemsProducts(
  Map<int, double> productsId,
  List<Product> products,
) {
  List<Product> newProductList = [];
  if (products.isEmpty) return [];
  for (int index in productsId.keys) {
    newProductList.add(products[index - 1]);
  }

  return newProductList;
}
