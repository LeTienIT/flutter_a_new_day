import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static const _radius = 14.0;

  /// ================= LIGHT =================
  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'DFVN',
      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.bgLight,

      /// TEXT
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
      ),

      /// APPBAR
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryLight,
      ),

      /// CARD
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),

      /// INPUT
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      /// BUTTON
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),

      /// SWITCH
      switchTheme: SwitchThemeData(
        thumbColor:
        WidgetStateProperty.all(AppColors.primary),
        trackColor:
        WidgetStateProperty.all(AppColors.primary.withOpacity(0.4)),
      ),

      /// ICON
      iconTheme: const IconThemeData(size: 22),
    );
  }

  /// ================= DARK =================
  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.black,
      secondary: AppColors.accent,
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.black,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'DFVN',
      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.bgDark,

      /// TEXT
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
        bodySmall: TextStyle(fontSize: 12, color: Colors.white60),
      ),

      /// APPBAR
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),

      /// CARD
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),

      /// INPUT
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      /// BUTTON
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),

      /// SWITCH
      switchTheme: SwitchThemeData(
        thumbColor:
        WidgetStateProperty.all(AppColors.accent),
        trackColor:
        WidgetStateProperty.all(AppColors.accent.withOpacity(0.4)),
      ),

      /// ICON
      iconTheme: const IconThemeData(
        color: Colors.white70,
        size: 22,
      ),
    );
  }
}