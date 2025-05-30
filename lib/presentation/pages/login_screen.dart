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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  void _handleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool authenticationStatus =
        ref.watch(authenticationProvider).isLoading;

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
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: LoginTemplate(
          path: 'assets/images/Logotipo.png',
          obscureText: obscureText,
          isLoadingButton: authenticationStatus,
          passwordController: _passwordController,
          usernameController: _usernameController,
          validatorUsername: formValidator,
          validatorPassword: formValidator,
          backonPressed: () {
            context.pop();
          },
          cartonPressed: () {
            context.go('/cart');
          },
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
          iconOnPressed: _handleObscureText,
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
