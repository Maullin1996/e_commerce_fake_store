import 'package:fake_store/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product', () {
    test('should create a Product with default quantity and no promotion', () {
      // Arrange
      final product = Product(
        id: 1,
        title: 'Test Product',
        price: 29.99,
        description: 'A simple product',
        category: 'general',
        image: 'image.png',
      );

      // Assert
      expect(product.quantity, equals(1));
      expect(product.isPromotion, isTrue);
      expect(product.discount, equals(0.1));
    });

    test('should recognize a promotional Product and apply discount', () {
      // Arrange
      final product = Product(
        id: 10,
        title: 'Promo Product',
        price: 50.0,
        description: 'Discounted product',
        category: 'sales',
        image: 'promo.png',
      );

      // Assert
      expect(product.isPromotion, isTrue);
      expect(product.discount, equals(0.1));
    });

    test('copyWith should return new instance with updated quantity', () {
      // Arrange
      final original = Product(
        id: 2,
        title: 'Original',
        price: 10.0,
        description: 'Original desc',
        category: 'cat',
        image: 'img.png',
      );
      // Act
      final updated = original.copyWith(quantity: 5);
      // Assert
      expect(updated.quantity, equals(5));
      expect(original.quantity, equals(1));
    });

    test('toJson and fromJson should work correctly', () {
      // Arrange
      final product = Product(
        id: 15,
        title: 'JSON Product',
        price: 100.0,
        description: 'Serialized product',
        category: 'promo',
        image: 'image.jpg',
        quantity: 3,
      );
      // Act
      final json = product.toJson();
      final fromJson = Product.fromJson(json);
      // Assert
      expect(fromJson.id, equals(product.id));
      expect(fromJson.title, equals(product.title));
      expect(fromJson.price, equals(product.price));
      expect(fromJson.quantity, equals(product.quantity));
      expect(fromJson.discount, equals(product.discount));
      expect(fromJson.isPromotion, isTrue);
    });

    test('== operator and hashCode should compare by id', () {
      // Arrange
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
      // Assert
      expect(productA, equals(productB));
      expect(productA.hashCode, equals(productB.hashCode));
    });
  });
}
