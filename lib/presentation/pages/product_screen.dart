import 'package:fake_store/domain/models.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends ConsumerWidget {
  // The product to display on this screen
  final Product product;

  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the favorite list to check if this product is marked as favorite
    final isFavorite = ref.watch(myFavoriteListProvider);

    return ProductTemplate(
      assetsImage: 'assets/images/error.png',
      // Pass whether the current product is favorite
      isFavorite: isFavorite.contains(product),
      url: product.image,
      id: product.id,
      description: product.description,
      productName: product.title,
      productPrice: product.price,
      isPromotion: product.isPromotion,
      discount: product.discount,

      // Navigate back when back button pressed
      backonPressed: () => context.pop(),

      // Navigate to cart screen
      cartonPressed: () => context.push('/cart'),

      // Toggle product as favorite or remove from favorites when pressed
      onPressedFavorite: () {
        ref.read(myFavoriteListProvider.notifier).toggleFavorite(product);
      },

      // Add product to cart and show notification accordingly
      onPressedbuy: () {
        if (ref.read(cartListProvider.notifier).addToCart(product)) {
          CustomFloatingNotifications().customNotification(
            TypeVerification.added,
          );
        } else {
          CustomFloatingNotifications().customNotification(
            TypeVerification.notAdded,
          );
        }
      },
    );
  }
}
