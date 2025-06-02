import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

/// A simple provider that returns true if there is either a cart or a logged-in user.
///
/// It listens to both `cartProvider` and `userInfoProvider` and
/// checks whether a cart or user data is available.
final hasCartOrUser = Provider<bool>((ref) {
  // Check if the cart is available (not null)
  final hasCart = ref.watch(cartProvider).carts != null;

  // Check if the user is logged in (not null)
  final hasUser = ref.watch(userInfoProvider).user != null;

  // Return true if either a cart or a user exists
  return hasCart || hasUser;
});
