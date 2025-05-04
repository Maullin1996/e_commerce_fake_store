import 'package:fake_store/domain/models.dart';
import 'package:fake_store/presentation/pages/cart_screen.dart';
import 'package:fake_store/presentation/pages/home_screen.dart';
import 'package:fake_store/presentation/pages/login_screen.dart';
import 'package:fake_store/presentation/pages/product_screen.dart';
import 'package:fake_store/presentation/pages/user_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter routers = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/product',
      builder: (context, state) {
        final Product product = state.extra as Product;
        return ProductScreen(product: product);
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/user', builder: (context, state) => const UserScreen()),
  ],
);
