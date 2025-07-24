import 'package:a_new_day/data/models/habit_status_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/tool.dart';

class HabitStatusItem extends StatelessWidget{
  final HabitStatusModel h;
  const HabitStatusItem({super.key, required this.h});

  @override
  Widget build(BuildContext context) {
    String trangThai = h.completed ? 'Hoàn thành' : 'Chưa hoàn thành';

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: h.completed ? Colors.green[400] : Colors.orange[400],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ngày: ${formatVietnameseDate(h.date)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Trạng thái: $trangThai',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          // Nút xem chi tiết bên phải
          IconButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'habit-status-detail',arguments: h.date);
            },
            icon: const Icon(Icons.remove_red_eye),
          ),
        ],
      ),
    );
  }
  
}