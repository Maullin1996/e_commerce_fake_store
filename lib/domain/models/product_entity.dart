/// A model representing a product in the e-commerce app.
class Product {
  /// The unique identifier for the product.
  final int id;

  /// The title or name of the product.
  final String title;

  /// The price of the product.
  final double price;

  /// A brief description of the product.
  final String description;

  /// The category to which the product belongs.
  final String category;

  /// The URL or path to the product's image.
  final String image;

  /// The quantity of the product in the cart. Defaults to 1.
  final int quantity;

  /// Creates a new [Product] instance with the provided values.
  ///
  /// The [quantity] argument defaults to 1 if not specified.
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.quantity = 1,
  });

  /// Returns a copy of this product with an optional updated [quantity].
  ///
  /// The returned product will have the same values as the original product
  /// except for the quantity if provided.
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      quantity:
          quantity ??
          this.quantity, // Use provided quantity or keep the current one.
    );
  }

  /// Compares two [Product] instances for equality.
  ///
  /// Two products are considered equal if they have the same [id].
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  /// Returns a hash code for the [Product].
  ///
  /// The hash code is based on the [id] to ensure that products with the same
  /// id have the same hash code, which is important for collections like [Set] and [Map].
  @override
  int get hashCode => id.hashCode;
}
