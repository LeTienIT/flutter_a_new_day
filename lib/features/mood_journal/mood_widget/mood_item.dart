import 'dart:io';

import 'package:a_new_day/data/models/mood_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/tool.dart';

class MoodItem extends StatefulWidget{
  final MoodModel mood;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MoodItem({super.key, required this.mood, required this.isActive, required this.onTap, required this.onView, required this.onEdit, required this.onDelete});

  @override
  State<StatefulWidget> createState() {
    return _MoodItem();
  }

}

class _MoodItem extends State<MoodItem>{

  @override
  Widget build(BuildContext context) {
    final parts = widget.mood.emoji.split('|');
    final imagePath = parts.first;
    final slogan = parts.length > 1 ? parts.last : '';

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatVietnameseDate(widget.mood.date), // "Thứ Hai, 15 Tháng 7 2023"
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Icon(Icons.person),
                      Image.asset(
                        imagePath,
                        width: 64,
                        height: 64,
                      ),
                      const SizedBox(width: 16),
                      // Slogan & Note (bên phải)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slogan,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.mood.note ?? 'Không có ghi chú',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                      label: const Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: widget.onEdit,
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Sửa'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: widget.onView,
                      icon: const Icon(Icons.remove_red_eye, size: 18, color: Colors.green),
                      label: const Text('Xem', style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

}