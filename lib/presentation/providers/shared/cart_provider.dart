import 'package:fake_store/domain/models/product_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartListProvider extends StateNotifier<List<Product>> {
  CartListProvider() : super([]);

  bool addToCart(Product product) {
    if (!state.contains(product)) {
      state = [...state, product];
      return true;
    } else {
      return false;
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.id != product.id).toList();
  }

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

  double get totalToPay {
    return state.fold(
      0.0,
      (total, product) => total + product.price * product.quantity,
    );
  }

  void emptyCart() {
    state = [];
  }
}

final cartListProvider = StateNotifierProvider<CartListProvider, List<Product>>(
  (ref) {
    return CartListProvider();
  },
);
