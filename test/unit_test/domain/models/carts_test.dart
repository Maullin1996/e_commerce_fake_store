import 'package:fake_store/domain/models/carts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const int id = 1;
  const int userId = 1;
  const List<Map<String, dynamic>> products = [
    {'productId': 1},
    {'productId': 2},
    {'productId': 3},
  ];
  group('Cart', () {
    test('should create an instance with the correct parameters', () {
      // Act
      final cart = Carts(id: id, userId: userId, products: products);
      //Assert
      expect(cart.id, equals(1));
    });
    test(
      'copyWith should return a new instance with the updated parameter',
      () {
        // Arrange
        final original = Carts(id: id, userId: userId, products: products);
        // Act
        final modified = original.copyWith(
          id: 2,
          products: [
            {'productId': 4},
          ],
        );

        // Assert
        expect(modified.id, equals(2));
        expect(original.id, equals(1));
        expect(modified.products[0], equals({'productId': 4}));
        expect(original.products.length, 3);
        expect(modified.products.length, 1);
      },
    );
    test('copyWith with no parameters should retain the original token', () {
      // Arrange
      final cart = Carts(id: id, userId: userId, products: products);
      // Act
      final copy = cart.copyWith();
      // Assert
      expect(copy.id, equals(cart.id));
    });
  });
}
