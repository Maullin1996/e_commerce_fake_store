import 'package:fake_store/domain/models.dart';
import 'package:fake_store/presentation/pages/cart_screen.dart';
import 'package:fake_store/presentation/pages/home_screen.dart';
import 'package:fake_store/presentation/pages/login_screen.dart';
import 'package:fake_store/presentation/pages/product_screen.dart';
import 'package:fake_store/presentation/pages/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final GoRouter routers = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionDuration: Duration(milliseconds: 800),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
        );
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/product',
      pageBuilder: (context, state) {
        final Product product = state.extra as Product;

        return CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: Duration(milliseconds: 500),
          child: ProductScreen(product: product),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/user', builder: (context, state) => const UserScreen()),
  ],
);
