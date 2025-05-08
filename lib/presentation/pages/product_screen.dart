import 'package:fake_store/domain/models.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends ConsumerWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(myFavoriteListProvider);

    return ProductTemplate(
      isFavorite: isFavorite.contains(product),
      url: product.image,
      description: product.description,
      productName: product.title,
      productPrice: product.price,
      isPromotion: product.isPromotion,
      discount: product.discount,
      backonPressed: () => context.pop(),
      cartonPressed: () => context.push('/cart'),
      onPressedFavorite: () {
        ref.read(myFavoriteListProvider.notifier).toggleFavorite(product);
      },
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
