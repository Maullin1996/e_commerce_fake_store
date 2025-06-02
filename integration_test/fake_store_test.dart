import 'package:integration_test/integration_test.dart';
import 'fake_store_verify_tap_test.dart' as verify_cart;
import 'fake_store_add_multiples_products_cart_test.dart'
    as add_various_elements_to_cart;
import 'fake_store_add_multiples_products_favorite_test.dart'
    as add_various_elements_to_favorite;
import 'fake_store_login_test.dart' as login;
import 'fake_store_buy_products_test.dart' as purchase;
import 'fake_store_navigate_cart_to_product_screen_test.dart'
    as navigate_cart_to_product;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  verify_cart.main();
  add_various_elements_to_cart.main();
  add_various_elements_to_favorite.main();
  login.main();
  purchase.main();
  navigate_cart_to_product.main();
}
