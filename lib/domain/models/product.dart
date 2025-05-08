import 'package:fake_store/config/mock/special_categories.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final int quantity;
  final bool isPromotion;
  final double discount;

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

  factory Product({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    int quantity = 1,
  }) {
    final isPromotion = SpecialCategories.saleItems.keys.contains(id);
    final discount = SpecialCategories.saleItems[id];

    return Product._(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      quantity: quantity,
      isPromotion: isPromotion,
      discount: discount ?? 1,
    );
  }

  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
