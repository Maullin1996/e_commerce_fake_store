import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final hasCartOrUser = Provider<bool>((ref) {
  final hasCart = ref.watch(cartProvider).carts != null;
  final hasUser = ref.watch(userInfoProvider).user != null;

  return hasCart || hasUser;
});
