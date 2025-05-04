import 'package:collection/collection.dart';
import 'package:fake_store/domain/models.dart';
import 'package:fake_store/domain/models/cart_entity.dart';
import 'package:fake_store/infraestructure/helppers/carts/cart_mapper.dart';
import 'package:fake_store/presentation/providers/api_response/user_provider.dart';
import 'package:fake_store/presentation/providers/shared/cart_provider.dart';
import 'package:fake_store_api_package/methods/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'products_provider.dart';

class CartApiResponse {
  final String? errorMessage;
  final Carts? carts;

  CartApiResponse({this.errorMessage, this.carts});

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
    state = state.copyWith(errorMessage: null);
    final cartResult = await _apiServices.fetchCarts();
    state = cartResult.fold(
      (failure) => state.copyWith(errorMessage: failure.message),
      (carts) {
        List<int> productList;
        final user = ref.watch(userInfoProvider).user;
        final List<Product> product = ref.watch(productsProvider).products;
        final cartsList =
            carts.map((cart) => CartsMapper.cartFakeStoreToCard(cart)).toList();
        if (user != null) {
          final userCart = cartsList.firstWhereOrNull(
            (cart) => user.id == cart.userId,
          );
          if (userCart!.products.isNotEmpty) {
            productList =
                userCart.products.map((e) => int.parse(e.toString())).toList();
            for (int productId in productList) {
              ref
                  .read(cartListProvider.notifier)
                  .addToCart(
                    product.firstWhere((element) => element.id == productId),
                  );
            }
          }
        }

        return state.copyWith(errorMessage: null);
      },
    );
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartApiResponse>((
  ref,
) {
  return CartNotifier(ref);
});
