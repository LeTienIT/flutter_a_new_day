import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:path/path.dart' as p;

enum AuthType {
  app,
  mood,
}

int getDaysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
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

Future<String?> resolveFilePath(String? storedPath) async {
  if (storedPath == null || storedPath.isEmpty) return null;

  final originalFile = File(storedPath);

  if (await originalFile.exists()) {
    return storedPath;
  }

  final fileName = p.basename(storedPath);

  final dir = await getApplicationDocumentsDirectory() ;

  final newPath = p.join(dir.path, fileName);

  final newFile = File(newPath);

  if (await newFile.exists()) {
    return newPath;
  }

  return null;
}

void showTopToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return _ToastWidget(message: message, onEnd: () => entry.remove());
    },
  );

  overlay.insert(entry);
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onEnd;

  const _ToastWidget({
    required this.message,
    required this.onEnd,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}
class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacity = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _offset = Tween(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(_controller);

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      await _controller.reverse();
      widget.onEnd();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Center( // 🔥 căn giữa
          child: FadeTransition(
            opacity: _opacity,
            child: SlideTransition(
              position: _offset,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: IntrinsicWidth( // 🔥 co theo nội dung
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7F00FF),
                          Color(0xFFE100FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // 🔥 quan trọng
                      children: [
                        const Icon(Icons.touch_app,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}