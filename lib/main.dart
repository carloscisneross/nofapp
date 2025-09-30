import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_theme.dart';
import 'app_router.dart';
import 'firebase/firebase_bootstrap.dart';
import 'core/providers.dart';
import 'core/app_lifecycle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with guarded initialization
  await FirebaseBootstrap.initialize();
  
  runApp(
    ProviderScope(
      child: NofApp(),
    ),
  );
}

class NofApp extends ConsumerWidget {
  const NofApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: 'nofApp',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
