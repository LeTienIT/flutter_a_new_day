import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

// ===== Hàm tạo file backup =====
Future<File> createFullBackup() async {
  final appDir = await getApplicationDocumentsDirectory();
  final tempDir = await getTemporaryDirectory();
  final copyDir = Directory(p.join(tempDir.path, 'backup_copy'));

  // Xóa thư mục backup cũ nếu tồn tại
  if (await copyDir.exists()) {
    await copyDir.delete(recursive: true);
  }
  await copyDir.create(recursive: true);

  // Sao chép nội dung
  await for (var entity in appDir.list(recursive: true)) {
    if (entity is File) {
      final newPath = p.join(copyDir.path, p.relative(entity.path, from: appDir.path));
      await File(newPath).parent.create(recursive: true);
      await entity.copy(newPath);
    }
  }

  final zipFilePath = p.join(
    tempDir.path,
    'backup_${DateTime.now().millisecondsSinceEpoch}.zip',
  );

  try {
    final encoder = ZipFileEncoder();
    encoder.create(zipFilePath);
    await encoder.addDirectory(copyDir);
    encoder.close();

    return File(zipFilePath);
  } catch (e) {
    debugPrint('Error creating zip: $e');
    rethrow;
  } finally {
    try {
      await copyDir.delete(recursive: true);
    } catch (e) {
      debugPrint('Error cleaning up: $e');
    }
  }
}

// ===== Lưu vào thư mục Downloads public =====
Future<void> backupAndSaveToDownloads() async {
  try {
    // Tạo backup tạm
    final backupFile = await createFullBackup();

    // Tên file có timestamp
    final fileName = 'backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.zip';

    if (Platform.isAndroid) {
      // Xin quyền lưu bộ nhớ ngoài
      if (await Permission.storage.request().isGranted) {
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }
        final savePath = p.join(downloadsDir.path, fileName);
        await backupFile.copy(savePath);

        debugPrint('✅ Đã lưu vào: $savePath');
      } else {
        debugPrint('❌ Không có quyền lưu file');
      }
    } else if (Platform.isIOS) {
      // Trên iOS không có "Downloads" public, nên lưu vào thư mục app
      final docsDir = await getApplicationDocumentsDirectory();
      final savePath = p.join(docsDir.path, fileName);
      await backupFile.copy(savePath);
      debugPrint('✅ Đã lưu vào Documents của app: $savePath');
    }
  } catch (e) {
    debugPrint('Lỗi khi lưu file: $e');
  }
}

/// Luôn đảm bảo phải đóng kết nối CSDL AppDatabase -> await db.close();
Future<bool> restoreBackup(File backupZip) async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final tempRestoreDir = Directory(p.join(appDir.parent.path, 'restore_temp'));

    // Xóa temp cũ nếu có
    if (await tempRestoreDir.exists()) {
      await tempRestoreDir.delete(recursive: true);
    }
    await tempRestoreDir.create(recursive: true);

    // Giải nén ra thư mục tạm
    final bytes = await backupZip.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filePath = p.join(tempRestoreDir.path, file.name);
      if (file.isFile) {
        final outFile = File(filePath);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      } else {
        await Directory(filePath).create(recursive: true);
      }
    }

    // Đường dẫn đến backup_copy sau khi giải nén
    final backupCopyDir = Directory(p.join(tempRestoreDir.path, 'backup_copy'));

    if (!await backupCopyDir.exists()) {
      throw Exception("Không tìm thấy thư mục backup_copy trong file zip");
    }

    // Xóa dữ liệu cũ
    if (await appDir.exists()) {
      await appDir.delete(recursive: true);
    }

    // Di chuyển dữ liệu từ backup_copy vào appDir
    await backupCopyDir.rename(appDir.path);

    // Xóa thư mục tempRestoreDir (nếu vẫn còn)
    if (await tempRestoreDir.exists()) {
      await tempRestoreDir.delete(recursive: true);
    }

    return true;
  } catch (e) {
    debugPrint("Restore failed: $e");
    return false;
  }
}


