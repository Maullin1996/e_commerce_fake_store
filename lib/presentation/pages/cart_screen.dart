import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fake_store/domain/models.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_design/template/tamplate.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current list of products in the cart
    final List<Product> cartList = ref.watch(cartListProvider);
    // Watch the authentication token to check if user is logged in
    final String token = ref.watch(authenticationProvider).token;
    // Watch the current logged-in user information
    final user = ref.watch(userInfoProvider).user;

    return CartTemplate(
      // Image to show in error or empty states
      assetsImage: 'assets/images/error.png',

      // Action when dialog button is pressed (for example: clear cart or navigate to login)
      onDialogButtonPressed: () {
        if (token.isEmpty) {
          // If not logged in, close dialog and go to login page
          context.pop();
          context.push('/login');
        } else {
          // If logged in, clear the cart, close dialog, and navigate home
          ref.read(cartListProvider.notifier).emptyCart();
          context.pop();
          context.go('/home');
        }
      },

      // Action to log out the user
      logOutonPressed: () {
        ref.read(authenticationProvider.notifier).logOutUser();
      },

      // Display user's last name or empty string if no user
      lastName: user == null ? '' : user.name.lastname,
      // Display user's first name or empty string if no user
      name: user == null ? '' : user.name.firstname,
      // Whether user is authenticated (token exists)
      authentication: token.isNotEmpty,
      // List of products currently in the cart
      listCart: cartList,
      // Total amount to pay formatted with 2 decimals
      totalToPay: ref
          .read(cartListProvider.notifier)
          .totalToPay
          .toStringAsFixed(2),

      // Action for back button press: just pop the current screen
      backonPressed: () {
        context.pop();
      },

      // Action for login button press: navigate to login screen
      logInonPressed: () {
        context.push('/login');
      },

      // Action to increase quantity of a product in the cart
      onPressedplus:
          (product) =>
              ref.read(cartListProvider.notifier).increaseQuantity(product),

      // Action to decrease quantity of a product in the cart
      onPressedminus:
          (product) =>
              ref.read(cartListProvider.notifier).decreaseQuantity(product),

      // Action to navigate to product details screen with the product data
      onPressedinfo: (product) => context.push('/product', extra: product),
    );
  }
}
