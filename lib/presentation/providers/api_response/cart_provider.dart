import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:fake_store/domain/models.dart';
import 'package:fake_store/infraestructure/helppers/carts/carts_mapper.dart';
import 'package:fake_store/presentation/providers/api_response/user_provider.dart';
import 'package:fake_store/presentation/providers/shared/cart_list_provider.dart';
import 'package:fake_store_api_package/methods/api_services.dart';

import 'products_provider.dart';

class CartApiResponse {
  final String errorMessage;
  final Carts? carts;

  CartApiResponse({this.errorMessage = '', this.carts});

  CartApiResponse copyWith({String? errorMessage, Carts? carts}) {
    return CartApiResponse(
      errorMessage: errorMessage ?? this.errorMessage,
      carts: carts ?? this.carts,
    );
  }
}

class CartNotifier extends StateNotifier<CartApiResponse> {
  final Ref ref;
  CartNotifier(this.ref) : super(CartApiResponse());
  final ApiServices _apiServices = ApiServices();

  Future<void> fetchAllCarts() async {
    state = state.copyWith(errorMessage: '');
    final cartResult = await _apiServices.fetchCarts();
    cartResult.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (carts) {
        final User? user = ref.watch(userInfoProvider).user;
        final List<Product> product = ref.watch(productsProvider).products;
        final cartsList =
            carts.map((cart) => CartsMapper.cartFakeStoreToCard(cart)).toList();
        if (user != null) {
          final userCart = cartsList.firstWhereOrNull(
            (cart) => user.id == cart.userId,
          );
          state = state.copyWith(errorMessage: '', carts: userCart);
          if (userCart != null && userCart.products.isNotEmpty) {
            for (Map<String, dynamic> productId in userCart.products) {
              ref
                  .read(cartListProvider.notifier)
                  .addToCart(
                    product.firstWhere(
                      (element) => element.id == productId["productId"],
                    ),
                  );
            }
          }
        }
      },
    );
  }

  void deleteUserCart() {
    final List<Product> product = ref.watch(productsProvider).products;
    if (state.carts != null) {
      if (state.carts?.products != null) {
        for (Map<String, dynamic> productId in state.carts!.products) {
          ref
              .read(cartListProvider.notifier)
              .removeFromCart(
                product.firstWhere(
                  (element) => element.id == productId["productId"],
                ),
              );
        }
      }
    }
    state = state.copyWith(carts: null);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartApiResponse>((
  ref,
) {
  return CartNotifier(ref);
});
