import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/const/setting_const.dart';
import '../../data/database/dao/setting_dao.dart';
import '../../data/database/providers/database_providers.dart';


/// Controller
class SettingsController {
  final SettingDao dao;

  SettingsController(this.dao);

  /// ===== GENERIC BOOL =====

  Future<void> initBool(String key, {bool defaultValue = false}) async {
    final value = await dao.getValue(key);

    if (value == null) {
      await dao.setValue(key, defaultValue.toString());
    }
  }
  Stream<bool> watchBool(String key) {
    return dao.watchValue(key).map((value) {
      return value == 'true';
    });
  }
  Future<void> setBool(String key, bool value) async {
    await dao.setValue(key, value.toString());
  }

  Future<void> initString(String key, {required String defaultValue}) async {
    final value = await dao.getValue(key);

    if (value == null) {
      await dao.setValue(key, defaultValue);
    }
  }
  Stream<String> watchString(String key) {
    return dao.watchValue(key).map((e) => e ?? '');
  }
  Future<void> setString(String key, String value) {
    return dao.setValue(key, value);
  }

  Future<void> initGradient() async {
    final start = await dao.getValue(SettingKeys.coverGradientStart);
    final end = await dao.getValue(SettingKeys.coverGradientEnd);

    if (start == null) {
      await dao.setValue(
        SettingKeys.coverGradientStart,
        _colorToHex(const Color(0xFFd7ccc8)),
      );
    }

    if (end == null) {
      await dao.setValue(
        SettingKeys.coverGradientEnd,
        _colorToHex(const Color(0xFFa1887f)),
      );
    }
  }
  String _colorToHex(Color c) {
    return c.value.toRadixString(16).padLeft(8, '0');
  }
  Stream<LinearGradient> watchGradient() {
    return Rx.combineLatest2(
      dao.watchValue(SettingKeys.coverGradientStart),
      dao.watchValue(SettingKeys.coverGradientEnd),
          (start, end) {
        final s = _hexToColor(start);
        final e = _hexToColor(end);

        return LinearGradient(
          colors: [s, e],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      },
    );
  }
  Color _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      return const Color(0xFFd7ccc8);
    }

    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return const Color(0xFFd7ccc8);
    }
  }
  Future<void> setGradient(Color start, Color end) async {
    await dao.setValue(
      SettingKeys.coverGradientStart,
      _colorToHex(start),
    );

    await dao.setValue(
      SettingKeys.coverGradientEnd,
      _colorToHex(end),
    );
  }

  Future<void> initColor(String key, {required Color defaultValue}) async {
    final value = await dao.getValue(key);

    if (value == null) {
      await dao.setValue(key, _colorToHex(defaultValue));
    }
  }
  Stream<Color> watchColor(String key) {
    return dao.watchValue(key).map((hex) {
      return _hexToColor(hex);
    });
  }
  Future<void> setColor(String key, Color color) async {
    await dao.setValue(key, _colorToHex(color));
  }
}

/// Provider controller
final settingsControllerProvider = Provider<SettingsController>((ref) {
  final dao = ref.watch(settingDaoProvider);
  return SettingsController(dao);
});

/// Init provider
final settingsInitProvider = FutureProvider<void>((ref) async {
  final controller = ref.read(settingsControllerProvider);

  await Future.wait([
    controller.initBool(SettingKeys.showCompleted),
    controller.initBool(SettingKeys.darkMode),

    controller.initString(
      SettingKeys.coverTitle,
      defaultValue: '<3 NHẬT KÝ CỦA TRÁI TIM S2',
    ),
    controller.initString(
      SettingKeys.coverSubtitle,
      defaultValue: '"Cảm xúc hôm nay là món quà của ngày mai"',
    ),
    controller.initColor(
      SettingKeys.coverTextColor,
      defaultValue: Colors.black,
    ),

    controller.initGradient(),
  ]);
});

/// State provider
final showCompletedProvider = StreamProvider<bool>((ref) {
  final controller = ref.watch(settingsControllerProvider);
  return controller.watchBool(SettingKeys.showCompleted);
});

final darkModeProvider = StreamProvider<bool>((ref) {
  final controller = ref.watch(settingsControllerProvider);
  return controller.watchBool(SettingKeys.darkMode);
});

final coverTitleProvider = StreamProvider<String>((ref) {
  final controller = ref.watch(settingsControllerProvider);
  return controller.watchString(SettingKeys.coverTitle);
});

final coverSubtitleProvider = StreamProvider<String>((ref) {
  final controller = ref.watch(settingsControllerProvider);
  return controller.watchString(SettingKeys.coverSubtitle);
});

final coverGradientProvider = StreamProvider<LinearGradient>((ref) {
  final controller = ref.watch(settingsControllerProvider);
  return controller.watchGradient();
});

final coverTextColorProvider = StreamProvider<Color>((ref) {
  final controller = ref.watch(settingsControllerProvider);
  return controller.watchColor(SettingKeys.coverTextColor);
});
