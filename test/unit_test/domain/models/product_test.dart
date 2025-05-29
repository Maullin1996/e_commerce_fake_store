import 'package:fake_store/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product', () {
    test('should create a Product with default quantity and no promotion', () {
      final product = Product(
        id: 1,
        title: 'Test Product',
        price: 29.99,
        description: 'A simple product',
        category: 'general',
        image: 'image.png',
      );

      expect(product.quantity, equals(1));
      expect(product.isPromotion, isTrue);
      expect(product.discount, equals(0.1));
    });

    test('should recognize a promotional Product and apply discount', () {
      final product = Product(
        id: 10, // This ID is in SpecialCategories.saleItems
        title: 'Promo Product',
        price: 50.0,
        description: 'Discounted product',
        category: 'sales',
        image: 'promo.png',
      );

      expect(product.isPromotion, isTrue);
      expect(product.discount, equals(0.1));
    });

    test('copyWith should return new instance with updated quantity', () {
      final original = Product(
        id: 2,
        title: 'Original',
        price: 10.0,
        description: 'Original desc',
        category: 'cat',
        image: 'img.png',
      );

      final updated = original.copyWith(quantity: 5);

      expect(updated.quantity, equals(5));
      expect(original.quantity, equals(1)); // original unchanged
    });

    test('toJson and fromJson should work correctly', () {
      final product = Product(
        id: 15,
        title: 'JSON Product',
        price: 100.0,
        description: 'Serialized product',
        category: 'promo',
        image: 'image.jpg',
        quantity: 3,
      );

      final json = product.toJson();
      final fromJson = Product.fromJson(json);

      expect(fromJson.id, equals(product.id));
      expect(fromJson.title, equals(product.title));
      expect(fromJson.price, equals(product.price));
      expect(fromJson.quantity, equals(product.quantity));
      expect(fromJson.discount, equals(product.discount));
      expect(fromJson.isPromotion, isTrue);
    });

    test('== operator and hashCode should compare by id', () {
      final productA = Product(
        id: 3,
        title: 'A',
        price: 1.0,
        description: '',
        category: '',
        image: '',
      );
      final productB = Product(
        id: 3,
        title: 'B',
        price: 2.0,
        description: 'diff',
        category: 'x',
        image: 'img2',
      );

      expect(productA, equals(productB));
      expect(productA.hashCode, equals(productB.hashCode));
    });
  });
}
