import 'package:fake_store/domain/models/product.dart';
import 'package:fake_store/infraestructure/helppers/mappers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mocks_api.dart';

void main() {
  test('should map succefully ProductsFakeStore to Products', () {
    // Act
    final listOfProducts =
        MocksApi.productMock
            .map((product) => ProductMapper.productFakeStoreToProduct(product))
            .toList();
    // Assert
    expect(listOfProducts, isA<List<Product>>());
    expect(listOfProducts.length, 3);
    expect(listOfProducts[1].id, equals(2));
    expect(listOfProducts[0].category, equals('ropa deportiva'));
    expect(
      listOfProducts[2].image,
      equals('https://example.com/images/spalding.jpg'),
    );
    expect(listOfProducts[2].price, equals(59.99));
    expect(
      listOfProducts[0].description,
      equals('Camiseta oficial de los Lakers, temporada 2024'),
    );
  });
}
