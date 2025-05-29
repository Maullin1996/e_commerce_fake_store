import 'package:fake_store/domain/models/carts.dart';
import 'package:fake_store/infraestructure/helppers/carts/carts_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mocks_api.dart';

void main() {
  test('should map succefully CartsFakeStore to Carts', () {
    // Act
    final listOfCarts =
        MocksApi.cartMock
            .map((carts) => CartsMapper.cartFakeStoreToCard(carts))
            .toList();
    // Assert
    expect(listOfCarts, isA<List<Carts>>());
    expect(listOfCarts.length, 3);
    expect(listOfCarts[0].id, equals(1));
    expect(listOfCarts[1].userId, equals(102));
    expect(listOfCarts.last.products[1], equals({'productId': 8}));
  });
}
