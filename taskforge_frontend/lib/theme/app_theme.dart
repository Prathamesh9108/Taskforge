import 'package:flutter/material.dart';

/// TaskForge Unified Design System
/// Inspired by Linear, Asana, and modern enterprise productivity software.
class AppTheme {
  // Brand & Accent Colors (Modern Indigo SaaS Palette)
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryHover = Color(0xFF4338CA); // Indigo 700
  static const Color primaryLight = Color(0xFFEEF2FF); // Indigo 50
  static const Color primaryBorder = Color(0xFFC7D2FE); // Indigo 200
  static const Color accentViolet = Color(0xFF7C3AED); // Violet 600

  // Surface & Neutral Colors
  static const Color background = Color(0xFFF8FAFC); // Soft off-white (Slate 50)
  static const Color surface = Color(0xFFFFFFFF); // Pure white cards
  static const Color surfaceSubtle = Color(0xFFF1F5F9); // Slate 100
  static const Color cardBorder = Color(0xFFE2E8F0); // Subtle light grey (Slate 200)
  static const Color cardBorderHover = Color(0xFFCBD5E1); // Slate 300
  static const Color divider = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Dark navy (Slate 900)
  static const Color textSecondary = Color(0xFF64748B); // Slate grey (Slate 500)
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400

  // Semantic Feedback Colors
  // Success (Tasteful Green)
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successBg = Color(0xFFECFDF5); // Emerald 50
  static const Color successBorder = Color(0xFFA7F3D0); // Emerald 200
  static const Color successText = Color(0xFF047857); // Emerald 700

  // Warning (Subtle Amber)
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningBg = Color(0xFFFFFBEB); // Amber 50
  static const Color warningBorder = Color(0xFFFDE68A); // Amber 200
  static const Color warningText = Color(0xFFB45309); // Amber 700

  // Danger / Error (Muted Red)
  static const Color danger = Color(0xFFEF4444); // Red 500
  static const Color dangerBg = Color(0xFFFEF2F2); // Red 50
  static const Color dangerBorder = Color(0xFFFECACA); // Red 200
  static const Color dangerText = Color(0xFFDC2626); // Red 600

  // Status Colors (Linear & Asana inspired subtle badges)
  // To Do: neutral slate
  static const Color todoBg = Color(0xFFF1F5F9);
  static const Color todoBorder = Color(0xFFE2E8F0);
  static const Color todoText = Color(0xFF475569);

  // In Progress: indigo
  static const Color inProgressBg = Color(0xFFEEF2FF);
  static const Color inProgressBorder = Color(0xFFC7D2FE);
  static const Color inProgressText = Color(0xFF4338CA);

  // Completed / Done: green
  static const Color doneBg = Color(0xFFECFDF5);
  static const Color doneBorder = Color(0xFFA7F3D0);
  static const Color doneText = Color(0xFF047857);

  // Subtle clean shadows (minimal elevation, preferring crisp 1px borders)
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x060F172A),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> hoverShadow = [
    BoxShadow(
      color: Color(0x0F0F172A),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  // Compact Radius Presets (10-14px)
  static final BorderRadius radiusXs = BorderRadius.circular(6);
  static final BorderRadius radiusSm = BorderRadius.circular(8);
  static final BorderRadius radiusMd = BorderRadius.circular(10);
  static final BorderRadius radiusLg = BorderRadius.circular(12);
  static final BorderRadius radiusXl = BorderRadius.circular(14);
  static final BorderRadius radiusFull = BorderRadius.circular(9999);

  // Spacing Scale Constants
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;

  // Status styling configuration
  static ({Color bg, Color border, Color text, IconData icon}) getStatusConfig(String? rawStatus) {
    final s = (rawStatus ?? '').toUpperCase().replaceAll(' ', '_');
    if (s == 'DONE' || s == 'COMPLETED') {
      return (
        bg: doneBg,
        border: doneBorder,
        text: doneText,
        icon: Icons.check_circle_rounded,
      );
    }
    if (s == 'IN_PROGRESS') {
      return (
        bg: inProgressBg,
        border: inProgressBorder,
        text: inProgressText,
        icon: Icons.timelapse_rounded,
      );
    }
    if (s == 'PLANNING') {
      return (
        bg: const Color(0xFFF5F3FF),
        border: const Color(0xFFDDD6FE),
        text: const Color(0xFF6D28D9),
        icon: Icons.auto_awesome_rounded,
      );
    }
    if (s == 'ACTIVE') {
      return (
        bg: inProgressBg,
        border: inProgressBorder,
        text: inProgressText,
        icon: Icons.play_circle_outline_rounded,
      );
    }
    if (s == 'ON_HOLD') {
      return (
        bg: surfaceSubtle,
        border: cardBorder,
        text: textSecondary,
        icon: Icons.pause_circle_outline_rounded,
      );
    }
    // Default To Do
    return (
      bg: todoBg,
      border: todoBorder,
      text: todoText,
      icon: Icons.radio_button_unchecked_rounded,
    );
  }

  // Priority styling configuration
  static ({Color bg, Color border, Color text, IconData icon}) getPriorityConfig(String? rawPriority) {
    final p = (rawPriority ?? '').toUpperCase();
    if (p == 'HIGH') {
      return (
        bg: dangerBg,
        border: dangerBorder,
        text: dangerText,
        icon: Icons.flag_rounded,
      );
    }
    if (p == 'LOW') {
      return (
        bg: const Color(0xFFF8FAFC),
        border: const Color(0xFFE2E8F0),
        text: const Color(0xFF64748B),
        icon: Icons.outlined_flag_rounded,
      );
    }
    // Default Medium (Amber)
    return (
      bg: warningBg,
      border: warningBorder,
      text: warningText,
      icon: Icons.flag_rounded,
    );
  }

  // Global Light Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: accentViolet,
        surface: surface,
        onSurface: textPrimary,
        outline: cardBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary, size: 20),
        actionsIconTheme: IconThemeData(color: textPrimary, size: 20),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: radiusLg,
          side: const BorderSide(color: cardBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(color: textMuted, fontSize: 13),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: const BorderSide(color: cardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: const BorderSide(color: cardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: const BorderSide(color: danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radiusMd,
          borderSide: const BorderSide(color: danger, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: radiusMd),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: cardBorder, width: 1),
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: radiusMd),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: radiusSm),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      splashFactory: InkRipple.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: radiusLg,
          side: const BorderSide(color: cardBorder, width: 1),
        ),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(
          color: textSecondary,
          fontSize: 13,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 60,
        backgroundColor: surface,
        elevation: 0,
        indicatorColor: primaryLight,
        indicatorShape: RoundedRectangleBorder(borderRadius: radiusMd),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? primary : textSecondary,
            letterSpacing: -0.1,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 20,
            color: isSelected ? primary : textSecondary,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
