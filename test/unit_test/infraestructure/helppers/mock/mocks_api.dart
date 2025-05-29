import 'package:fake_store_api_package/infraestructure/helppers/mappers.dart';

abstract class MocksApi {
  static final List<CartsFakeStore> cartMock = [
    CartsFakeStore(
      id: 1,
      userId: 101,
      productsId: [
        CartItem(productId: 5),
        CartItem(productId: 12),
        CartItem(productId: 23),
      ],
    ),
    CartsFakeStore(
      id: 2,
      userId: 102,
      productsId: [CartItem(productId: 7), CartItem(productId: 19)],
    ),
    CartsFakeStore(
      id: 3,
      userId: 103,
      productsId: [
        CartItem(productId: 3),
        CartItem(productId: 8),
        CartItem(productId: 15),
        CartItem(productId: 22),
      ],
    ),
  ];

  static final List<ProductsFakeStore> productMock = [
    ProductsFakeStore(
      id: 1,
      title: 'Camiseta NBA Lakers',
      price: 29.99,
      description: 'Camiseta oficial de los Lakers, temporada 2024',
      category: 'ropa deportiva',
      image: 'https://example.com/images/lakers.jpg',
    ),
    ProductsFakeStore(
      id: 2,
      title: 'Gorra Chicago Bulls',
      price: 19.50,
      description: 'Gorra ajustable con logo bordado de los Bulls',
      category: 'accesorios',
      image: 'https://example.com/images/bulls-cap.jpg',
    ),
    ProductsFakeStore(
      id: 3,
      title: 'Balón Spalding Oficial NBA',
      price: 59.99,
      description: 'Balón oficial con logo de la NBA, tamaño estándar',
      category: 'equipamiento',
      image: 'https://example.com/images/spalding.jpg',
    ),
  ];

  static final List<UsersFakeStore> userMock = [
    UsersFakeStore(
      id: 1,
      email: 'lebron.james@example.com',
      username: 'kingjames',
      password: 'goat23',
      phone: '555-0123',
      apiName: ApiName(firstname: 'LeBron', lastname: 'James'),
      apiAddress: ApiAddress(
        city: 'Los Angeles',
        street: 'Staples Ave',
        number: 23,
        zipcode: '90015',
      ),
    ),
    UsersFakeStore(
      id: 2,
      email: 'michael.jordan@example.com',
      username: 'mj23',
      password: 'chicagoGOAT',
      phone: '555-0456',
      apiName: ApiName(firstname: 'Michael', lastname: 'Jordan'),
      apiAddress: ApiAddress(
        city: 'Chicago',
        street: 'United Center St',
        number: 45,
        zipcode: '60612',
      ),
    ),
    UsersFakeStore(
      id: 3,
      email: 'stephen.curry@example.com',
      username: 'chef30',
      password: 'splashbro',
      phone: '555-0789',
      apiName: ApiName(firstname: 'Stephen', lastname: 'Curry'),
      apiAddress: ApiAddress(
        city: 'San Francisco',
        street: 'Chase Center Blvd',
        number: 30,
        zipcode: '94158',
      ),
    ),
  ];

  static final TokenFakeStore tokenMock = TokenFakeStore(
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mockTokenExample123',
  );
}
