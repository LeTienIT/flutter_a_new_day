import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate({
    required BuildContext context,
    bool showError = true,
    String reason = 'Vui lòng xác thực để tiếp tục',
  }) async {
    final bool canCheck = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    if (!canCheck) {
      if (showError) {
        _showSnackBar(context, 'Thiết bị không hỗ trợ xác thực');
      }
      return false;
    }

    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      if (!didAuthenticate && showError) {
        _showSnackBar(context, 'Xác thực thất bại hoặc bị huỷ');
      }

      return didAuthenticate;
    } catch (e) {
      if (showError) {
        _showSnackBar(context, 'Lỗi xác thực: $e');
      }
      return false;
    }
  }

  static void _showSnackBar(BuildContext context, String msg) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}
