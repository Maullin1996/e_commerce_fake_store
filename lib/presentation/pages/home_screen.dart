import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:fake_store/domain/models.dart';
import 'package:fake_store/presentation/providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Current selected category filter
  String selectedCategory = 'All';

  // List of available product categories
  final List<String> categories = [
    'All', // Display all categories
    'Featured', // Top products
    'Sale Items', // Products on sale
    'Favorite', // User's favorite products
    'electronics', // Electronics category
    'jewelery', // Jewelry category
    "men's clothing", // Men's clothing category
    "women's clothing", // Women's clothing category
  ];

  // Pull-to-refresh handler: reload all products from the API
  Future<void> _pullToRefresh() async {
    await ref.read(productsProvider.notifier).fetchAllProducts();
  }

  // Handler to update selected category in provider
  void _handleCategorySelection(String category) {
    ref.read(productsProvider.notifier).setCategory(category);
  }

  // Toggle favorite status for a product
  void _handleIsFavorite(product) {
    ref.read(myFavoriteListProvider.notifier).toggleFavorite(product);
  }

  // Add product to cart and show custom notification depending on success
  void _handleBuyProduct(product) {
    if (ref.read(cartListProvider.notifier).addToCart(product)) {
      CustomFloatingNotifications().customNotification(TypeVerification.added);
    } else {
      CustomFloatingNotifications().customNotification(
        TypeVerification.notAdded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch products state to get current products and category info
    final productSate = ref.watch(productsProvider);
    // Watch favorite products list
    final List<Product> myFavoriteList = ref.watch(myFavoriteListProvider);
    // Watch cart products list
    final List<Product> myCartList = ref.watch(cartListProvider);
    // Watch authentication state for user token
    final authenticationState = ref.watch(authenticationProvider);
    // Watch logged-in user data
    final userProvider = ref.watch(userInfoProvider).user;

    // Decide which product list to display based on selected category
    List<Product> products;
    (productSate.selectedCategory == 'Favorite')
        ? products = myFavoriteList
        : products = productSate.filteredProducts;

    return GestureDetector(
      // Dismiss keyboard when tapping outside inputs
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: HomeTemplate(
        // UI details like assets and contact info
        assetsImage: 'assets/images/error.png',
        // address: 'CRA 88A # 55W - 44 Sur Medellin',
        // email: 'allstorehouse@correo.com',
        // instagram: 'all.storehouse',
        // whatsapp: '(+57) 3354425145',

        // Categories to display for filtering
        categories: categories,
        // Check if user is logged in by token presence
        isLogIn: authenticationState.token.isNotEmpty,
        // Show user's first name or empty if not logged in
        name: userProvider == null ? '' : userProvider.name.firstname,
        // Show user's last name or empty if not logged in
        lastName: userProvider == null ? '' : userProvider.name.lastname,
        // Show error message if any from products state
        errorMessage: productSate.errorMessage,
        // Show loading indicator if products are being fetched
        isLoading: productSate.isLoading,
        // Products to display (filtered or favorites)
        products: products,
        // Favorites list
        myFavoriteList: myFavoriteList,
        // Cart list
        myCartList: myCartList,
        // Current selected category
        selectedCategory: productSate.selectedCategory,

        // Callbacks for UI interactions
        onCategorySelected: _handleCategorySelection,
        onPressedinfo: (product) {
          context.push('/product', extra: product);
        },
        onPressedFavorite: _handleIsFavorite,
        onPressedbuy: _handleBuyProduct,
        cartonPressed: () {
          context.push('/cart');
        },
        logInonPressed: () {
          context.push('/login');
        },
        useronPressed: () {
          context.push('/user');
        },
        logOutonPressed: () {
          ref.read(authenticationProvider.notifier).logOutUser();
        },
        onItemSelected: (String selectedItem) {
          final Product selectedProduct = products.firstWhere(
            (product) => product.title == selectedItem,
          );
          context.push('/product', extra: selectedProduct);
        },
        // Refresh products on pull down
        refreshProducts: _pullToRefresh,
      ),
    );
  }
}
