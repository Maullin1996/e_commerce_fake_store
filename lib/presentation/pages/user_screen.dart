import 'package:fake_store_design/template/user_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fake_store/presentation/providers/providers.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch user info provider to get current user data and loading status
    final userProvider = ref.watch(userInfoProvider);
    final userInfo = userProvider.user;

    // Show loading indicator if data is still loading or user is null
    if (userProvider.isLoading || userInfo == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Display user details using UserTemplate
    return UserTemplate(
      // Navigate back when back button pressed
      backonPressed: () {
        context.pop();
      },

      // Navigate to cart screen
      cartonPressed: () {
        context.go('/cart');
      },

      // Log out the user and navigate to home screen
      logOutonPressed: () {
        ref.read(authenticationProvider.notifier).logOutUser();
        context.go('/home');
      },

      // Pass user details to the template
      lastName: userInfo.name.lastname,
      name: userInfo.name.firstname,
      username: userInfo.username,
      email: userInfo.email,
      phone: userInfo.phone,
      city: userInfo.address.city,
      street: userInfo.address.street,
      number: userInfo.address.number.toString(),
      zipcode: userInfo.address.zipcode,
    );
  }
}
