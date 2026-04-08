import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/setting/setting_controller.dart';

final appThemeProvider = Provider<ThemeMode>((ref) {
  final darkModeAsync = ref.watch(darkModeProvider);

  return darkModeAsync.when(
    data: (isDark) => isDark ? ThemeMode.dark : ThemeMode.light,
    loading: () => ThemeMode.light,
    error: (_, __) => ThemeMode.light,
  );
});