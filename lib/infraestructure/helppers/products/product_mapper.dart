import 'package:fake_store/domain/models/product_entity.dart';
import 'package:fake_store_api_package/infraestructure/helppers/mappers/products/products_fake_store.dart';

/// A mapper class for converting between [ProductsFakeStore] and [Product] entities.
class ProductMapper {
  /// Converts a [ProductsFakeStore] instance to a [Product] instance.
  ///
  /// Takes a [ProductsFakeStore] object and maps its properties to create
  /// a new [Product] object.
  static Product productFakeStoreToProduct(ProductsFakeStore productFakeStore) {
    return Product(
      id: productFakeStore.id,
      title: productFakeStore.title,
      price: productFakeStore.price,
      description: productFakeStore.description,
      category: productFakeStore.category,
      image: productFakeStore.image,
    );
  }
}
