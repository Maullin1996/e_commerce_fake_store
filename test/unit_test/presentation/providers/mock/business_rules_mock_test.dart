import 'package:fake_store/domain/models.dart';

class BusinessRulesMockTest {
  // User Mock
  static final List<User> mockUsers = [
    User(
      address: const Address(
        city: 'New York',
        street: 'Broadway',
        number: 123,
        zipcode: '10001-0000',
      ),
      id: 1,
      email: 'john.doe@example.com',
      username: 'johndoe',
      password: 'password123',
      name: const Name(firstname: 'John', lastname: 'Doe'),
      phone: '1-212-555-0123',
    ),
    User(
      address: const Address(
        city: 'Los Angeles',
        street: 'Sunset Blvd',
        number: 45,
        zipcode: '90210-0000',
      ),
      id: 2,
      email: 'jane.smith@example.com',
      username: 'janesmith',
      password: 'securepassword',
      name: const Name(firstname: 'Jane', lastname: 'Smith'),
      phone: '1-310-555-0456',
    ),
    User(
      address: const Address(
        city: 'Chicago',
        street: 'Michigan Ave',
        number: 789,
        zipcode: '60601-0000',
      ),
      id: 3,
      email: 'peter.jones@example.com',
      username: 'peterj',
      password: 'mysecretpassword',
      name: const Name(firstname: 'Peter', lastname: 'Jones'),
      phone: '1-312-555-0789',
    ),
  ];

  // Cart Mock
  static final List<Carts> mockCarts = [
    const Carts(
      id: 1,
      userId: 1,
      products: [
        {'productId': 1},
        {'productId': 3},
      ],
    ),
    const Carts(
      id: 2,
      userId: 2,
      products: [
        {'productId': 2},
        {'productId': 4},
        {'productId': 5},
      ],
    ),
    const Carts(
      id: 3,
      userId: 1,
      products: [
        {'productId': 1},
        {'productId': 5},
      ],
    ),
  ];

  static final List<Product> mockProducts = [
    Product(
      id: 1,
      title: 'Wireless Bluetooth Headphones',
      price: 59.99,
      description:
          'Experience immersive audio with these comfortable and stylish wireless Bluetooth headphones. Perfect for music lovers on the go.',
      category: 'Electronics',
      image: 'https://example.com/images/headphones.jpg',
      quantity: 1,
    ),
    Product(
      id: 2,
      title: 'Ergonomic Office Chair',
      price: 199.99,
      description:
          'Boost your productivity and comfort with this ergonomic office chair. Designed for long hours of sitting, it provides excellent lumbar support.',
      category: 'Home Office',
      image: 'https://example.com/images/office_chair.jpg',
      quantity: 1,
    ),
    Product(
      id: 3,
      title: 'Stainless Steel Water Bottle',
      price: 15.50,
      description:
          'Stay hydrated with this durable and eco-friendly stainless steel water bottle. Keeps your drinks cold for hours.',
      category: 'Kitchen & Dining',
      image: 'https://example.com/images/water_bottle.jpg',
      quantity: 1,
    ),
    Product(
      id: 4,
      title: 'Portable Power Bank 10000mAh',
      price: 29.99,
      description:
          'Never run out of battery again with this high-capacity portable power bank. Compatible with all smartphones and tablets.',
      category: 'Electronics',
      image: 'https://example.com/images/power_bank.jpg',
      quantity: 1,
    ),
    Product(
      id: 5,
      title: 'Yoga Mat with Carrying Strap',
      price: 24.00,
      description:
          'Enhance your yoga practice with this non-slip, comfortable yoga mat. Includes a convenient carrying strap for easy transport.',
      category: 'Sports & Outdoors',
      image: 'https://example.com/images/yoga_mat.jpg',
      quantity: 1,
    ),
    Product(
      id: 6,
      title: 'Smart LED Light Bulb',
      price: 12.99,
      description:
          'Control your lighting from anywhere with this smart LED light bulb. Compatible with voice assistants and offers customizable colors.',
      category: 'Smart Home',
      image: 'https://example.com/images/smart_bulb.jpg',
      quantity: 1,
    ),
  ];

  static final mockToken = Auth(token: 'token');
}

class SpecialCategories {
  static const Map<int, double> saleItems = {
    1: 0.15, // Product with ID 1 has a 15% discount
    4: 0.20, // Product with ID 4 has a 20% discount
    // Add more products with discounts as needed
  };
}
