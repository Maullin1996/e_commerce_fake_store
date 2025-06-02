import 'package:fake_store/domain/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of favorite products.
class FavoriteListProvider extends StateNotifier<List<Product>> {
  /// Initializes the favorite list with an optional initial state.
  FavoriteListProvider(super.state);

  /// Adds a product to the favorites list.
  void addToFavorite(Product product) {
    state = [...state, product];
  }

  /// Removes a product from the favorites list.
  void removeToFavorite(Product product) {
    state = [...state]..remove(product);
  }

  /// Checks if a product is in the favorites list.
  bool isFavorite(Product product) {
    return state.contains(product);
  }

  /// Toggles the favorite status of a product.
  /// Adds the product if it's not already favorite; removes it otherwise.
  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      removeToFavorite(product);
    } else {
      addToFavorite(product);
    }
  }
}

/// Provider to access and manage the list of favorite products.
final myFavoriteListProvider =
    StateNotifierProvider<FavoriteListProvider, List<Product>>((ref) {
      return FavoriteListProvider([]);
    });
