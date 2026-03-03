import 'package:flutter/material.dart';

import '../../../core/utils/tool.dart';

List<Widget> buildNotePages(BuildContext context, String? note) {
  if (note == null || note.trim().isEmpty) return [];

  final size = MediaQuery.of(context).size;
  const padding = EdgeInsets.all(18);
  const margin = EdgeInsets.all(16);
  final maxWidth = size.width - padding.horizontal - margin.horizontal - 80;
  final maxHeight = size.height - padding.vertical - margin.vertical;
  final style = const TextStyle(fontSize: 18, height: 1.2);

  final pages = splitNoteToPages(
    note: note,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    style: style,
  );

  return pages.map((pageText) => Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: const Color(0xFFFBF6EF),
        border: const Border(
          right: BorderSide(color: Color(0xFFD6C6B5), width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.15),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(
          children: [
            Text(
              pageText,
              style: style,
              textAlign: TextAlign.justify,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/emoji_default/arrow.png',
                width: 30,
                height: 20,
                fit: BoxFit.fill,
              ),
            ),
          ]
      )
  )).toList();
}