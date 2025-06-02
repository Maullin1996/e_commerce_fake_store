// Abstract class to define special product categories and discounts
abstract class SpecialCategories {
  // List of product IDs that are featured
  static List<int> featured = [1, 3, 5, 6, 8, 4, 7, 5, 15, 12];

  // Map of product IDs to their discount percentages
  // Represents items currently on sale
  // Format: {ProductId : discount}, where discount is a value between 0 and 1 (e.g., 0.1 = 10%)
  static Map<int, double> saleItems = {
    1: 0.1, // 10% discount
    9: 0.15, // 15% discount
    10: 0.1, // 10% discount
    2: 0.2, // 20% discount
    13: 0.5, // 50% discount
    14: 0.12, // 12% discount
    15: 0.08, // 8% discount
  };
}
