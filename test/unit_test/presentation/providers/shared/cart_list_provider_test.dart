import 'package:fake_store/presentation/providers/shared/cart_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/business_rules_mock.dart';

void main() {
  late ProviderContainer container;

  group('Cart list Provider', () {
    setUp(() {
      container = ProviderContainer(
        overrides: [cartListProvider.overrideWith((ref) => CartListProvider())],
      );
      addTearDown(container.dispose);
    });

    test('should add product to the cart', () {
      // Act
      container
          .read(cartListProvider.notifier)
          .addToCart(BusinessRulesMock.mockProducts[0]);

      final state = container.read(cartListProvider);

      // Assert
      expect(state.length, equals(1));
      expect(
        state[0].image,
        equals('https://example.com/images/headphones.jpg'),
      );
      expect(state[0].price, equals(59.99));
    });

    test('should add various products to the  cart', () {
      // Act
      for (var product in BusinessRulesMock.mockProducts) {
        container.read(cartListProvider.notifier).addToCart(product);
      }
      final state = container.read(cartListProvider);
      // Assert
      expect(state.length, equals(6));
      expect(state[3].price, equals(29.99));
    });
    test('should not add duplicate elements', () {
      expect(
        container
            .read(cartListProvider.notifier)
            .addToCart(BusinessRulesMock.mockProducts[1]),
        isTrue,
      );
      expect(
        container
            .read(cartListProvider.notifier)
            .addToCart(BusinessRulesMock.mockProducts[1]),
        isFalse,
      );
    });
    test('should remove a specific  element', () {
      // Act
      for (var product in BusinessRulesMock.mockProducts) {
        container.read(cartListProvider.notifier).addToCart(product);
      }
      container
          .read(cartListProvider.notifier)
          .removeFromCart(BusinessRulesMock.mockProducts[1]);
      final state = container.read(cartListProvider);

      //Assert
      expect(state.contains(BusinessRulesMock.mockProducts[1]), isFalse);
    });
    test('Increase the quantity of a specific product', () {
      // Act
      for (var product in BusinessRulesMock.mockProducts) {
        container.read(cartListProvider.notifier).addToCart(product);
      }
      for (var i = 0; i < 5; i++) {
        container
            .read(cartListProvider.notifier)
            .increaseQuantity(BusinessRulesMock.mockProducts[1]);
      }
      final state = container.read(cartListProvider);

      expect(state[1].quantity, equals(6));
    });
    test('Decrease the quantity of a specific product', () {
      // Act
      for (var product in BusinessRulesMock.mockProducts) {
        container.read(cartListProvider.notifier).addToCart(product);
      }
      for (var i = 0; i < 5; i++) {
        container
            .read(cartListProvider.notifier)
            .increaseQuantity(BusinessRulesMock.mockProducts[1]);
      }
      for (var i = 0; i < 2; i++) {
        container
            .read(cartListProvider.notifier)
            .decreaseQuantity(BusinessRulesMock.mockProducts[1]);
      }
      final state = container.read(cartListProvider);

      expect(state[1].quantity, equals(4));
    });
    test('should remove the product if quantity == 0', () {
      // Act
      for (var product in BusinessRulesMock.mockProducts) {
        container.read(cartListProvider.notifier).addToCart(product);
      }
      for (var i = 0; i < 5; i++) {
        container
            .read(cartListProvider.notifier)
            .increaseQuantity(BusinessRulesMock.mockProducts[1]);
      }
      for (var i = 0; i < 6; i++) {
        container
            .read(cartListProvider.notifier)
            .decreaseQuantity(BusinessRulesMock.mockProducts[1]);
      }
      final state = container.read(cartListProvider);

      expect(state.contains(BusinessRulesMock.mockProducts[1]), isFalse);
    });
    test('Empty the list of products in the cart', () {
      // Act
      for (var product in BusinessRulesMock.mockProducts) {
        container.read(cartListProvider.notifier).addToCart(product);
      }
      final state = container.read(cartListProvider);
      // Assert
      expect(state.length, equals(6));
      // Empty the cart
      container.read(cartListProvider.notifier).emptyCart();
      final emptyCart = container.read(cartListProvider);
      expect(emptyCart.length, equals(0));
    });
    test(
      'Sould return the amount of money to pay base on the amount of products',
      () {
        // Act
        for (var product in BusinessRulesMock.mockProducts) {
          container.read(cartListProvider.notifier).addToCart(product);
        }
        expect(
          container.read(cartListProvider.notifier).totalToPay,
          equals(296.463),
        );
      },
    );
  });
}
