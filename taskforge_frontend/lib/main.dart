import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

class ThemeController {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);
}

void main() {
  runApp(const TaskForgeApp());
}

class TaskForgeApp extends StatelessWidget {
  const TaskForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDarkMode,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TaskForge',

          // ============================
          // LIGHT THEME
          // ============================
          theme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2563EB),
              brightness: Brightness.light,
            ),

            scaffoldBackgroundColor: const Color(0xFFF8FAFC),

            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF0F172A),
              elevation: 0,
            ),
          ),

          // ============================
          // DARK THEME
          // ============================
          darkTheme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2563EB),
              brightness: Brightness.dark,
            ),

            scaffoldBackgroundColor: const Color(0xFF0F172A),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              elevation: 0,
            ),

            cardTheme: const CardThemeData(color: Color(0xFF1E293B)),

            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E293B),
            ),
          ),

          // ============================
          // GLOBAL THEME MODE
          // ============================
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

          home: const SplashScreen(),
        );
      },
    );
  }
}
