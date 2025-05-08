import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fake_store_design/design_system.dart';

//import 'package:fake_store/presentation/helpers/category_selected.dart';
import 'package:fake_store/domain/models.dart';
import 'package:fake_store/presentation/providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All', // Display all categories.
    'Featured', // Top products.
    'Sale Items', // Best price.
    "Favorite", // Category base on your preference.
    "electronics", // Category for electronics.
    "jewelery", // Category for jewelery.
    "men's clothing", // Category for men's clothing.
    "women's clothing", // Category for women's clothing.
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(productsProvider.notifier).fetchAllProducts();
    });
  }

  void _handleCategorySelection(String category) {
    setState(() {
      selectedCategory = category;
    });
    ref.read(selectedCategoryProvider.notifier).state = category;
  }

  void _handleIsFavorite(product) {
    ref.read(myFavoriteListProvider.notifier).toggleFavorite(product);
  }

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
    final productApiResponse = ref.watch(productsProvider);
    final List<Product> myFavoriteList = ref.watch(myFavoriteListProvider);
    final List<Product> myCartList = ref.watch(cartListProvider);
    final List<Product> products = ref.watch(productsByCategory);
    final authenticationState = ref.watch(authenticationProvider);
    final userProvider = ref.watch(userInfoProvider).user;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: HomeTamplate(
        address: 'CRA 88A # 55W - 44 Sur Medellin',
        email: 'allstorehouse@correo.com',
        instagram: 'all.storehouse',
        whatsapp: '(+57) 3354425145',
        categories: categories,
        isLogIn: authenticationState.token.isNotEmpty,
        name: userProvider == null ? '' : userProvider.name.firstname,
        lastName: userProvider == null ? '' : userProvider.name.lastname,
        errorMessage: productApiResponse.errorMessage,
        isLoading: productApiResponse.isLoading,
        products: products,
        myFavoriteList: myFavoriteList,
        myCartList: myCartList,
        selectedCategory: selectedCategory,
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
      ),
    );
  }
}
