import 'package:fake_store/presentation/helpers/form_validator.dart';
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
  // Controllers for username and password text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Key to validate the login form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controls whether the password field is obscured or visible
  bool obscureText = true;

  // Toggle password visibility
  void _handleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch authentication loading state to show loading indicator
    final bool authenticationStatus =
        ref.watch(authenticationProvider).isLoading;

    // Listen for authentication errors to show error notification
    ref.listen<AuthenticationApiResponse>(authenticationProvider, (
      previous,
      current,
    ) {
      if (current.errorMessage.isNotEmpty) {
        CustomFloatingNotifications(
          errorMessage: current.errorMessage,
        ).customNotification(TypeVerification.errorMessage);
      }
    });

    // Listen to whether a cart or user exists, to automatically pop login screen
    ref.listen<bool>(hasCartOrUser, (previous, current) {
      if (current) {
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
        // Dismiss keyboard when tapping outside of inputs
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: LoginTemplate(
          path: 'assets/images/Logotipo.png',
          obscureText: obscureText,
          isLoadingButton: authenticationStatus,
          passwordController: _passwordController,
          usernameController: _usernameController,
          validatorUsername: formValidator,
          validatorPassword: formValidator,
          // Go back when back button pressed
          backonPressed: () {
            context.pop();
          },
          // Navigate to cart screen
          cartonPressed: () {
            context.go('/cart');
          },
          // On login button pressed, validate form and call authentication method
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Future(() async {
                await ref
                    .read(authenticationProvider.notifier)
                    .fetchAuthentication(
                      _usernameController.text,
                      _passwordController.text,
                    );
              });
            }
          },
          // Toggle password visibility icon pressed
          iconOnPressed: _handleObscureText,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when widget removed to free resources
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
