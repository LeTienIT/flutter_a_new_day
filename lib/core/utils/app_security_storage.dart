import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecurityStorage {
  static final _storage = FlutterSecureStorage();

  static const _appLockKey = 'is_app_locked';
  static const _moodLockKey = 'is_mood_locked';
  static const _pinKey = 'pin_code';
  static const _q1Key = 'security_q1';
  static const _a1Key = 'security_a1';
  static const _q2Key = 'security_q2';
  static const _a2Key = 'security_a2';

  static const _pinKeyMood = 'mood_pin_code';
  static const _q1KeyM = 'security_q1_M';
  static const _a1KeyM = 'security_a1_M';
  static const _q2KeyM = 'security_q2_M';
  static const _a2KeyM = 'security_a2_M';

  static bool _moodUnlockedOnce = false;

  static bool get hasUnlockedMoodOnce => _moodUnlockedOnce;

  static void setMoodUnlockedOnce(bool unlocked) {
    _moodUnlockedOnce = unlocked;
  }

  static Future<void> setAppLockEnabled(bool enabled) async {
    await _storage.write(key: _appLockKey, value: enabled.toString());
  }

  static Future<bool> isAppLockEnabled() async {
    final value = await _storage.read(key: _appLockKey);
    return value == 'true';
  }

  static Future<void> setMoodLockEnabled(bool enabled) async {
    await _storage.write(key: _moodLockKey, value: enabled.toString());
  }

  static Future<bool> isMoodLockEnabled() async {
    final value = await _storage.read(key: _moodLockKey);
    return value == 'true';
  }

  static Future<void> resetAll() async {
    await _storage.deleteAll();
  }
  static Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  static Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  static Future<bool> verifyPin(String input) async {
    final stored = await getPin();
    return stored == input;
  }

  static Future<void> saveSecurityQuestions(String q1, String a1, String q2, String a2) async {
    await _storage.write(key: _q1Key, value: q1);
    await _storage.write(key: _a1Key, value: a1);
    await _storage.write(key: _q2Key, value: q2);
    await _storage.write(key: _a2Key, value: a2);
  }
  static Future<List<String?>> getQuestion() async{
    final q1 = await _storage.read(key: _q1Key);
    final q2 = await _storage.read(key: _q2Key);
    return [q1,q2];
  }
  static Future<bool> verifyQuestion(String q1, String q2) async {
    final a1 = await _storage.read(key: _a1Key);
    final a2 = await _storage.read(key: _a2Key);
    return a1==q1&&a2==q2;
  }

  static Future<void> saveSecurityQuestionsM(String q1, String a1, String q2, String a2) async {
    await _storage.write(key: _q1KeyM, value: q1);
    await _storage.write(key: _a1KeyM, value: a1);
    await _storage.write(key: _q2KeyM, value: q2);
    await _storage.write(key: _a2KeyM, value: a2);
  }

  static Future<List<String?>> getQuestionM() async{
    final q1 = await _storage.read(key: _q1KeyM);
    final q2 = await _storage.read(key: _q2KeyM);
    return [q1,q2];
  }
  static Future<bool> verifyQuestionM(String q1, String q2) async {
    final a1 = await _storage.read(key: _a1KeyM);
    final a2 = await _storage.read(key: _a2KeyM);
    return a1==q1&&a2==q2;
  }
  static Future<void> savePinM(String pin) async {
    await _storage.write(key: _pinKeyMood, value: pin);
  }

  static Future<String?> getPinM() async {
    return await _storage.read(key: _pinKeyMood);
  }

  static Future<bool> verifyPinM(String input) async {
    final stored = await getPinM();
    return stored == input;
  }
}
