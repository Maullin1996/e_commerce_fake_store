import 'package:fake_store/presentation/providers/api_response/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:fake_store/presentation/providers/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isAuthenticated = false; // Nuevo estado para controlar la navegación

  @override
  Widget build(BuildContext context) {
    final loginProvider = ref.watch(authenticationProvider);

    ref.listen<AuthenticationApiResponse>(authenticationProvider, (
      previous,
      current,
    ) async {
      if (current.errorMessage != null &&
          previous?.errorMessage != current.errorMessage) {
        CustomFloatingNotifications(
          errorMessage: current.errorMessage,
        ).customNotification(TypeVerification.errorMessage);
      }
      if (current.token.isNotEmpty && !_isAuthenticated) {
        _isAuthenticated = true;
        await ref.read(userInfoProvider.notifier).fetchAllUsers();
        await ref.read(cartProvider.notifier).fetchAllCarts();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.pop();
          }
        });
      }
    });

    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: LoginTemplate(
          isLoadingButton: loginProvider.isLoading,
          passwordController: _passwordController,
          usernameController: _usernameController,
          validatorUsername: (username) {
            if (username == null || username.isEmpty) {
              return 'Empty Field';
            }
            return null;
          },
          validatorPassword: (password) {
            if (password == null || password.isEmpty) {
              return 'Empty Field';
            }
            return null;
          },
          backonPressed: () {
            context.pop();
          },
          cartonPressed: () {
            context.go('/cart');
          },
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await ref
                  .read(authenticationProvider.notifier)
                  .fetchAuthentication(
                    _usernameController.text,
                    _passwordController.text,
                  );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
