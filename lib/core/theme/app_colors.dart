import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const primary = Color(0xFF2ECC71);
  static const primaryDark = Color(0xFF27AE60);

  static const secondary = Color(0xFF00C2A8);
  static const accent = Color(0xFF00E5A0);

  // Neutral
  static const bgLight = Color(0xFFF8FAFC);
  static const bgDark = Color(0xFF0F172A);

  static const surfaceLight = Colors.white;
  static const surfaceDark = Color(0xFF1E293B);

  // Text
  static const textPrimaryLight = Color(0xFF0F172A);
  static const textSecondaryLight = Color(0xFF64748B);

  static const textPrimaryDark = Colors.white;
  static const textSecondaryDark = Color(0xFF94A3B8);

  /// LIGHT
  static const paperLight = Color(0xFFFBF6EF);
  static const paperGradientLight = [
    Color(0xFFFBF6EF),
    Color(0xFFEED9C4),
  ];

  /// DARK
  static const paperDark = Color(0xFF1E1E1E);
  static const paperGradientDark = [
    Color(0xFF1E1E1E),
    Color(0xFF2A2A2A),
  ];

  static const inkLight = Color(0xFF3E3E3E);
  static const inkDark = Colors.white;

  static const accentLight = Color(0xFFA1887F);
  static const accentDark = Color(0xFFD7CCC8);

}
extension ThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}