import 'dart:io';

import 'package:a_new_day/data/models/habit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitItem extends StatefulWidget{
  final HabitModel h;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitItem({
    super.key,
    required this.h,
    required this.isActive,
    required this.onTap,
    required this.onView,
    required this.onEdit,
    required this.onDelete
  });

  @override
  State<StatefulWidget> createState() {
    return _HabitItem();
  }
}

class _HabitItem extends State<HabitItem>{
  final List<String> _dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.h.icon != null && widget.h.icon!.isNotEmpty) ?
                  CircleAvatar(backgroundImage: FileImage(File(widget.h.icon!)), radius: 30,) :
                  CircleAvatar(radius: 30, child: Icon(Icons.insert_emoticon_outlined),),
                  const SizedBox(width: 12),

                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.h.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            getRepeatDayLabels(widget.h.repeatDays).join(', '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )
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
                    // const SizedBox(width: 8),
                    // TextButton.icon(
                    //   onPressed: widget.onView,
                    //   icon: const Icon(Icons.remove_red_eye, size: 18, color: Colors.green),
                    //   label: const Text('Xem', style: TextStyle(color: Colors.green)),
                    // ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  List<String> getRepeatDayLabels(List<int> repeatDays) {
    return repeatDays
        .where((day) => day >= 1 && day <= 7)
        .map((day) => _dayLabels[day - 1])
        .toList();
  }
}