import 'package:fake_store/domain/models/carts.dart';
import 'package:fake_store_api_package/infraestructure/helpers/mappers.dart';

/// A mapper class for converting between [CartsFakeStore] and [Carts] entities.
class CartsMapper {
  /// Converts a [CartsFakeStore] instance to a [Carts] instance.
  ///
  /// Takes a [CartsFakeStore] object and maps its properties to create
  /// a new [Carts] object.
  static Carts cartFakeStoreToCard(CartsFakeStore cardFakeStore) {
    return Carts(
      id: cardFakeStore.id,
      userId: cardFakeStore.userId,
      products:
          cardFakeStore.productsId.map((product) => product.toJson()).toList(),
    );
  }
}
