class SettingMapper {
  static bool toBool(String? value) => value == 'true';

  static String fromBool(bool value) => value.toString();

  static int toInt(String? value) => int.tryParse(value ?? '') ?? 0;

  static String fromInt(int value) => value.toString();
}