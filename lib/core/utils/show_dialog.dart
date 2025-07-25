import 'package:flutter/material.dart';

class CustomDialog{

  static Future<void> showMessageDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Đóng',
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'Hủy',
    String confirmText = 'Đồng ý',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}