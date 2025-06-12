import 'package:fake_store/my_app.dart';
import 'package:fake_store_design/config/atomic_design_config.dart';
import 'package:fake_store_design/config/semantics_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AtomicDesignConfig.initializeFromAsset('assets/design/copys.json');
  await SemanticsConfig.initializeFromAsset(
    'assets/locale/en/semantics_json.json',
  );
  runApp(ProviderScope(child: const MyApp()));
}
