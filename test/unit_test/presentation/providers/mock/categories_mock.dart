import 'package:fake_store/domain/models/product.dart';

class CategoriesMock {
  static final List<Product> mockProducts = [
    Product(
      id: 1,
      title: "Wireless Bluetooth Headphones",
      price: 49.99,
      description: "High-quality over-ear headphones with noise cancellation.",
      category: "electronics",
      image: "https://example.com/images/headphones.jpg",
    ),
    Product(
      id: 2,
      title: "Smartphone 128GB",
      price: 699.99,
      description: "Latest model with AMOLED display and long battery life.",
      category: "electronics",
      image: "https://example.com/images/smartphone.jpg",
    ),
    Product(
      id: 3,
      title: "Diamond Pendant Necklace",
      price: 399.95,
      description: "Elegant 14K gold necklace with a genuine diamond pendant.",
      category: "jewelery",
      image: "https://example.com/images/necklace.jpg",
    ),
    Product(
      id: 4,
      title: "Gold Plated Ring",
      price: 89.99,
      description: "Stylish ring made of sterling silver with gold plating.",
      category: "jewelery",
      image: "https://example.com/images/ring.jpg",
    ),
    Product(
      id: 5,
      title: "Men's Casual T-Shirt",
      price: 19.99,
      description: "Comfortable cotton T-shirt available in various colors.",
      category: "men's clothing",
      image: "https://example.com/images/mens_tshirt.jpg",
    ),
    Product(
      id: 6,
      title: "Men's Slim Fit Jeans",
      price: 39.99,
      description: "Stylish jeans designed for comfort and durability.",
      category: "men's clothing",
      image: "https://example.com/images/mens_jeans.jpg",
    ),
    Product(
      id: 7,
      title: "Women's Summer Dress",
      price: 29.95,
      description: "Light and breathable dress perfect for summer outings.",
      category: "women's clothing",
      image: "https://example.com/images/womens_dress.jpg",
    ),
    Product(
      id: 8,
      title: "Women's Leather Handbag",
      price: 89.50,
      description: "Elegant and durable handbag made from genuine leather.",
      category: "women's clothing",
      image: "https://example.com/images/womens_handbag.jpg",
    ),
    Product(
      id: 9,
      title: "Wireless Charger",
      price: 25.00,
      description: "Fast wireless charging pad compatible with all Qi devices.",
      category: "electronics",
      image: "https://example.com/images/charger.jpg",
    ),
    Product(
      id: 10,
      title: "Men's Hoodie",
      price: 34.95,
      description:
          "Warm fleece hoodie with a comfortable fit and modern style.",
      category: "men's clothing",
      image: "https://example.com/images/mens_hoodie.jpg",
    ),
  ];
  static final mockFavorite = [
    Product(
      id: 6,
      title: "Men's Slim Fit Jeans",
      price: 39.99,
      description: "Stylish jeans designed for comfort and durability.",
      category: "men's clothing",
      image: "https://example.com/images/mens_jeans.jpg",
    ),
    Product(
      id: 7,
      title: "Women's Summer Dress",
      price: 29.95,
      description: "Light and breathable dress perfect for summer outings.",
      category: "women's clothing",
      image: "https://example.com/images/womens_dress.jpg",
    ),
    Product(
      id: 8,
      title: "Women's Leather Handbag",
      price: 89.50,
      description: "Elegant and durable handbag made from genuine leather.",
      category: "women's clothing",
      image: "https://example.com/images/womens_handbag.jpg",
    ),
  ];
}

class SpecialCategories {
  static final Map<int, double> saleItems = {
    1: 0.15, // Product with ID 1 has a 15% discount
    4: 0.20, // Product with ID 4 has a 20% discount
  };
  static List<int> featured = [3, 5, 6, 8, 4]; // Product Id
}
