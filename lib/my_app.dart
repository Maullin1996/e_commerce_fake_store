import 'package:fake_store/config/router/router.dart';
import 'package:fake_store_design/design_system.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routers,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
    );
  }
}
