import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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
