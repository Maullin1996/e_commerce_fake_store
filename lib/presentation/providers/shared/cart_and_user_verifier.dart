import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final cartUserVerifier = Provider<bool>((ref) {
  final cartProviderVerifier = ref.watch(cartProvider).carts;
  final userProviderVerifier = ref.watch(userInfoProvider).user;

  if (cartProviderVerifier == null && userProviderVerifier == null) false;

  return true;
});
