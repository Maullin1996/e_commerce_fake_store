import 'package:fake_store/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:fake_store/domain/models.dart';
import 'package:fake_store/infraestructure/helppers/carts/carts_mapper.dart';
import 'package:fake_store_api_package/methods/api_services.dart';

/// Represents the state of the Cart API request
class CartApiResponse {
  final String errorMessage; // Holds any error message from the API
  final bool isLoading; // Indicates if data is currently being loaded
  final Carts? carts; // Holds the user's cart data, if available

  CartApiResponse({this.isLoading = false, this.errorMessage = '', this.carts});

  /// Allows partial updates to the state using optional named parameters
  CartApiResponse copyWith({
    String? errorMessage,
    Object? carts =
        _sentinel, // Special flag to distinguish between null and not passed
    bool? isLoading,
  }) {
    return CartApiResponse(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      carts: carts == _sentinel ? this.carts : carts as Carts?,
    );
  }

  // Private sentinel object used to detect omitted cart values
  static const _sentinel = Object();
}

/// StateNotifier to manage the cart data fetching and transformation
class CartNotifier extends StateNotifier<CartApiResponse> {
  final Ref ref;
  final ApiServices apiServices;

  CartNotifier(this.ref, this.apiServices) : super(CartApiResponse());

  /// Fetches all carts from the API and updates state for the current user
  Future<void> fetchAllCarts() async {
    final List<Product> product = ref.read(productsProvider).allProducts;

    // Set loading state
    state = state.copyWith(errorMessage: '', isLoading: true);

    // Fetch carts from API
    final cartResult = await apiServices.fetchCarts();

    // Handle result using Either (dartz)
    cartResult.fold(
      // API failure: update error and stop loading
      (failure) {
        state = state.copyWith(errorMessage: failure.message, isLoading: false);
      },
      // API success
      (carts) {
        final User? user = ref.watch(userInfoProvider).user;

        // Map external API carts to internal format
        final cartsList =
            carts.map((cart) => CartsMapper.cartFakeStoreToCard(cart)).toList();

        // If no user found, return with error
        if (user == null) {
          state = state.copyWith(
            errorMessage: 'User Not Found',
            carts: null,
            isLoading: false,
          );
        }

        // If user is found, locate their cart
        if (user != null) {
          final userCart = cartsList.firstWhereOrNull(
            (cart) => user.id == cart.userId,
          );

          // Update state with the user's cart
          state = state.copyWith(
            errorMessage: '',
            carts: userCart,
            isLoading: false,
          );

          // Load products from cart into the cartListProvider (UI/logic layer)
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

  /// Removes the user's cart and clears the cart list provider
  void deleteUserCart() {
    final allProducts = ref.read(productsProvider).allProducts;

    if (state.carts != null) {
      if (state.carts?.products != null) {
        for (Map<String, dynamic> productId in state.carts!.products) {
          ref
              .read(cartListProvider.notifier)
              .removeFromCart(
                allProducts.firstWhere(
                  (element) => element.id == productId["productId"],
                ),
              );
        }
      }
    }

    // Clear the cart state
    state = state.copyWith(carts: null);
  }
}

/// Provider to expose the CartNotifier state and functionality
final cartProvider = StateNotifierProvider<CartNotifier, CartApiResponse>((
  ref,
) {
  return CartNotifier(ref, ApiServices());
});
