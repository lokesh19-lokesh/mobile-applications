import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/splash_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://viqpwrttemnajhjvxsqp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZpcXB3cnR0ZW1uYWpoanZ4c3FwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEwODc1NTIsImV4cCI6MjA5NjY2MzU1Mn0.nACZXJlEWoX0CoLlEr6XwmXY9ol9qwK9Q9-hKdgSVDs',
  );
  runApp(
    const ProviderScope(
      child: RentMyShirtApp(),
    ),
  );
}

class RentMyShirtApp extends StatelessWidget {
  const RentMyShirtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wearbox',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
