import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = await SessionStore.load();
  runApp(
    ProviderScope(
      overrides: [initialSessionProvider.overrideWithValue(session)],
      child: const TraydcraftApp(),
    ),
  );
}

class TraydcraftApp extends ConsumerWidget {
  const TraydcraftApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'traydcraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2F5D62),
        visualDensity: VisualDensity.compact,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
