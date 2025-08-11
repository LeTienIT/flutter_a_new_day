import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

enum AuthType {
  app,
  mood,
}

String formatVietnameseDate(DateTime date) {
  const weekdays = {
    1: 'Thứ Hai',
    2: 'Thứ Ba',
    3: 'Thứ Tư',
    4: 'Thứ Năm',
    5: 'Thứ Sáu',
    6: 'Thứ Bảy',
    7: 'Chủ Nhật',
  };

  final weekdayName = weekdays[date.weekday] ?? '';
  final day = date.day;
  final month = date.month;
  final year = date.year;

  return '$weekdayName, ngày $day tháng $month NĂM $year';
}

String formatDuration(Duration d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
}

List<String> splitNoteToPages({required String note, required double maxWidth, required double maxHeight, required TextStyle style,}) {
  final words = note.split(RegExp(r'\s+'));
  final pages = <String>[];
  String current = '';

  for (final word in words) {
    final test = current.isEmpty ? word : '$current $word';

    final tp = TextPainter(
      text: TextSpan(text: test, style: style),
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    if (tp.height > maxHeight) {
      if (current.isEmpty) {
        pages.add(word);
        current = '';
      } else {
        pages.add(current.trim());
        current = word;
      }
    } else {
      current = test;
    }
  }

  if (current.isNotEmpty) {
    pages.add(current.trim());
  }

  return pages;
}

DateTime normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

Future<void> cleanOnlyCache() async {
  try {
    // 1. Xóa thư mục cache tạm thời (temporary directory)
    final tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
      await tempDir.create(); // Tạo lại thư mục rỗng
    }

    // 2. Xóa cache của các package (image, network...)
    await DefaultCacheManager().emptyCache(); // cached_network_image
    // Xóa cache của Dio (nếu dùng)
    final dioCacheDir = Directory('${tempDir.path}/dio');
    if (await dioCacheDir.exists()) await dioCacheDir.delete(recursive: true);

    // 3. Xóa cache WebView (nếu app dùng WebView)
    final appDir = await getApplicationSupportDirectory();
    final webViewCacheDir = Directory('${appDir.path}/WebKit');
    if (await webViewCacheDir.exists()) {
      await webViewCacheDir.delete(recursive: true);
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<int> getCacheSizeInBytes() async {
  int totalSize = 0;
  final tempDir = await getTemporaryDirectory();

  if (await tempDir.exists()) {
    totalSize = await _getDirectorySize(tempDir);
  }

  return totalSize;
}

Future<int> _getDirectorySize(Directory dir) async {
  int size = 0;
  try {
    final List<FileSystemEntity> entities = dir.listSync(recursive: true, followLinks: false);
    for (final entity in entities) {
      if (entity is File) {
        size += await entity.length();
      }
    }
  } catch (e) {
    throw("Error calculating directory size: $e");
  }
  return size;
}

String formatBytes(int bytes, [int decimals = 2]) {
  if (bytes == 0) return "0 B";
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
  final i = (bytes > 0) ? (log(bytes) / log(1024)).floor() : 0;
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${sizes[i]}';
}

