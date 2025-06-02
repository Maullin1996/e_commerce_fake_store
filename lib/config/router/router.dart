import 'package:fake_store/domain/models.dart';
import 'package:fake_store/presentation/pages.dart';
import 'package:fake_store/presentation/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Defines the application's route system using GoRouter, managed by Riverpod.
final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    // Initial screen when the app starts
    initialLocation: '/home',

    // Redirect logic that controls access based on login and other conditions
    redirect: (context, state) {
      // Retrieve the token from the authentication provider (e.g., representing a password or session token)
      final String token = ref.read(authenticationProvider).password;

      // Check if either user info or a cart exists
      final bool userAndCartVerification = ref.read(hasCartOrUser);

      // Check if the current route is the login screen
      final isLoggingIn = state.path == '/login';

      // Redirect logged-in users away from the login screen to home
      if (token.isNotEmpty && isLoggingIn && userAndCartVerification) {
        return '/home';
      }

      // No redirection by default
      return null;
    },

    // App routes
    routes: <RouteBase>[
      // Home screen route with custom transition
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

      // Cart screen route
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),

      // Product screen route with a fade transition and passed product data
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

      // Login screen route
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // User profile/settings screen route
      GoRoute(path: '/user', builder: (context, state) => const UserScreen()),
    ],
  ),
);
