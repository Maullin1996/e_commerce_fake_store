import 'package:fake_store/config/mock/special_categories.dart';

// Represents a product in the application
class Product {
  final int id; // Unique identifier for the product
  final String title; // Product title or name
  final double price; // Regular price (before discount)
  final String description; // Product description
  final String category; // Category the product belongs to
  final String image; // URL to product image
  final int quantity; // Quantity in cart or list (default: 1)
  final bool isPromotion; // Whether this product has a discount
  final double discount; // Discount value (0.1 = 10%, etc.)

  // Private named constructor used by the main factory and copyWith
  const Product._({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.quantity,
    required this.isPromotion,
    required this.discount,
  });

  // Factory constructor for initializing a product from basic parameters
  factory Product({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    int quantity = 1, // Default quantity is 1
  }) {
    // Check if the product ID is listed in the saleItems map
    final isPromotion = SpecialCategories.saleItems.keys.contains(id);

    // Get the discount value from saleItems, or null if not present
    final discount = SpecialCategories.saleItems[id];

    // Return a fully initialized product, applying promotion values if present
    return Product._(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      quantity: quantity,
      isPromotion: isPromotion,
      discount:
          discount ?? 1, // If no discount found, assign 1 (i.e., no discount)
    );
  }

  // Creates a copy of the product with optional modifications (used for immutability)
  Product copyWith({int? quantity}) {
    return Product._(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      quantity: quantity ?? this.quantity,
      isPromotion: isPromotion,
      discount: discount,
    );
  }

  // Converts the Product object into a Map (used for storage, APIs, etc.)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'quantity': quantity,
      'isPromotion': isPromotion,
      'discount': discount,
    };
  }

  // Creates a Product object from a Map (typically from an API or local storage)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product._(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      quantity: json['quantity'],
      isPromotion: json['isPromotion'],
      discount: (json['discount'] as num).toDouble(),
    );
  }

  // Overrides equality check: two products are considered equal if they share the same ID
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  // Overrides hashCode to match equality logic
  @override
  int get hashCode => id.hashCode;
}
