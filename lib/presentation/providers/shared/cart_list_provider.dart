import 'package:fake_store/domain/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the list of products added to the shopping cart.
class CartListProvider extends StateNotifier<List<Product>> {
  /// Initializes with an empty cart.
  CartListProvider() : super([]);

  /// Adds a product to the cart if it's not already present.
  /// Returns true if added successfully, false if product was already in the cart.
  bool addToCart(Product product) {
    if (!state.contains(product)) {
      state = [...state, product];
      return true;
    } else {
      return false;
    }
  }

  /// Removes the specified product from the cart.
  void removeFromCart(Product product) {
    state = state.where((item) => item.id != product.id).toList();
  }

  /// Increases the quantity of the specified product in the cart by 1.
  void increaseQuantity(Product product) {
    final index = state.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      final updatedProduct = state[index].copyWith(
        quantity: state[index].quantity + 1,
      );
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) updatedProduct else state[i],
      ];
    }
  }

  /// Decreases the quantity of the specified product in the cart by 1.
  /// If quantity reaches 0, removes the product from the cart.
  void decreaseQuantity(Product product) {
    final index = state.indexWhere((item) => item.id == product.id);
    if (index != -1 && state[index].quantity > 1) {
      final updatedProduct = state[index].copyWith(
        quantity: state[index].quantity - 1,
      );
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) updatedProduct else state[i],
      ];
    } else if (index != -1 && state[index].quantity == 1) {
      removeFromCart(product);
    }
  }

  /// Calculates the total amount to pay, considering promotions and quantities.
  double get totalToPay {
    return state.fold(
      0.0,
      (total, product) =>
          total +
          (product.isPromotion
                  ? product.price - product.price * product.discount
                  : product.price) *
              product.quantity,
    );
  }

  /// Empties the cart by clearing all products.
  void emptyCart() {
    state = [];
  }
}

/// Provider for accessing the CartListProvider and its state.
final cartListProvider = StateNotifierProvider<CartListProvider, List<Product>>(
  (ref) {
    return CartListProvider();
  },
);
