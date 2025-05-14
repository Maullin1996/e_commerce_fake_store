import 'package:fake_store/presentation/providers/shared/products_category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:fake_store/domain/models.dart';
import 'package:fake_store/infraestructure/helppers/carts/carts_mapper.dart';
import 'package:fake_store/presentation/providers/api_response/user_provider.dart';
import 'package:fake_store/presentation/providers/shared/cart_list_provider.dart';
import 'package:fake_store_api_package/methods/api_services.dart';

class CartApiResponse {
  final String errorMessage;
  final bool isLoading;
  final Carts? carts;

  CartApiResponse({this.isLoading = false, this.errorMessage = '', this.carts});

  CartApiResponse copyWith({
    String? errorMessage,
    Carts? carts,
    bool? isLoading,
  }) {
    return CartApiResponse(
      isLoading: isLoading ?? this.isLoading,
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
    final List<Product> product = await ref.read(localProductsProvider.future);
    state = state.copyWith(errorMessage: '', isLoading: true);
    final cartResult = await _apiServices.fetchCarts();
    cartResult.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message, isLoading: false);
      },
      (carts) {
        final User? user = ref.watch(userInfoProvider).user;
        final cartsList =
            carts.map((cart) => CartsMapper.cartFakeStoreToCard(cart)).toList();
        if (user != null) {
          final userCart = cartsList.firstWhereOrNull(
            (cart) => user.id == cart.userId,
          );
          state = state.copyWith(
            errorMessage: '',
            carts: userCart,
            isLoading: false,
          );
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
    final asyncProducts = ref.read(localProductsProvider);

    asyncProducts.when(
      data: (data) {
        if (state.carts != null) {
          if (state.carts?.products != null) {
            for (Map<String, dynamic> productId in state.carts!.products) {
              ref
                  .read(cartListProvider.notifier)
                  .removeFromCart(
                    data.firstWhere(
                      (element) => element.id == productId["productId"],
                    ),
                  );
            }
          }
        }
      },
      error: (_, _) => [],
      loading: () => [],
    );

    state = state.copyWith(carts: null);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartApiResponse>((
  ref,
) {
  return CartNotifier(ref);
});
