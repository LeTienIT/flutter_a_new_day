// file: theme/dark_theme.dart
import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
    primary: Colors.tealAccent,
    onPrimary: Colors.black,
    secondary: Colors.green,
    onSecondary: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white70,
    error: Colors.redAccent,
    onError: Colors.black,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white,fontFamily: 'DFVN'),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70, fontFamily: 'DFVN'),
    bodySmall: TextStyle(fontSize: 12, color: Colors.white60, fontFamily: 'DFVN'),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'DFVN'),
  ),

  cardTheme: const CardThemeData(
    color: Color(0xFF1E1E1E),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    margin: EdgeInsets.all(8),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.green,
    foregroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.green),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.tealAccent, width: 2),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.greenAccent,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),

  iconTheme: const IconThemeData(
    color: Colors.white70,
    size: 24,
  ),
);