import 'package:fake_store/domain/models/product_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteListProvider extends StateNotifier<List<Product>> {
  FavoriteListProvider(super.state);

  void addToFavorite(Product product) {
    state = [...state, product];
  }

  void removeToFavorite(Product product) {
    state = [...state]..remove(product);
  }

  bool isFavorite(Product product) {
    return state.contains(product);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      removeToFavorite(product);
    } else {
      addToFavorite(product);
    }
  }
}

final myFavoriteListProvider =
    StateNotifierProvider<FavoriteListProvider, List<Product>>((ref) {
      return FavoriteListProvider([]);
    });
