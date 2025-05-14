import 'package:fake_store/domain/models.dart';
import 'package:fake_store/presentation/pages.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final String token = ref.read(authenticationProvider).password;
      final bool userAndCartVerification = ref.read(hasCartOrUser);
      final isLoggingIn = state.path == '/login';

      if (token.isNotEmpty && isLoggingIn && userAndCartVerification) '/home';

      return null;
    },
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
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/user', builder: (context, state) => const UserScreen()),
    ],
  ),
);
