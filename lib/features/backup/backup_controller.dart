import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../../data/database/providers/database_providers.dart';

const platform = MethodChannel('letienit.a_new_day.saf');

Future<File> createBackupNative() async {
  final tempDir = await getTemporaryDirectory();
  final path = '${tempDir.path}/backup_native.zip';

  await platform.invokeMethod('createBackupNative', {
    'destPath': path,
  });

  return File(path);
}

Future<void> saveLargeBackup(File zipFile) async {
  try {
    await platform.invokeMethod('openSafAndSave', {
      'srcPath': zipFile.path,
      "fileName": "backup_${DateTime.now().millisecondsSinceEpoch}.zip"
    });
  } on PlatformException catch (e) {
    throw Exception("Lỗi khi lưu backup: ${e.message}");
  }
}

///Chọn file thông qua channel
Future<File?> pickBackupZipNative() async {
  final path = await platform.invokeMethod<String>('pickBackupZip');
  if (path != null) {
    return File(path);
  }
  return null;
}

/// Luôn đảm bảo phải đóng kết nối CSDL AppDatabase -> await db.close();
Future<bool> restoreBackup(File backupZip) async {

  try {
    await platform.invokeMethod('restoreBackupNative', {
      'zipPath': backupZip!.path,
    });

    return true;
  } catch (e) {
    debugPrint('Restore failed: $e');
    return false;
  }
}


