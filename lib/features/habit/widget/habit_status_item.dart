import 'package:a_new_day/core/utils/show_dialog.dart';
import 'package:a_new_day/data/database/providers/database_providers.dart';
import 'package:a_new_day/data/models/habit_status_model.dart';
import 'package:a_new_day/features/habit/provider/habit_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_security_storage.dart';
import '../../../core/utils/tool.dart';
import '../../security/authen_screen.dart';

class HabitStatusItem extends ConsumerWidget{
  final HabitStatusModel h;
  const HabitStatusItem({super.key, required this.h});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String trangThai = h.completed ? 'Hoàn thành' : 'Chưa hoàn thành';
    final now = DateTime.now();
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
          Wrap(
            children: [
              if(!(h.date.year == now.year && h.date.month == now.month && h.date.day == now.day))...[
                IconButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () async{
                    final confirm = await CustomDialog.showConfirmDialog(
                        context: context,
                        title: 'Xác nhận xóa',
                        message: 'Chắc chắn muốn xóa ngày này?'
                    );

                    if(confirm){
                      await ref.read(habitHistoryProvider.notifier).deleteHabitStatus(h);
                      CustomDialog.showMessageDialog(
                          context: context,
                          title: 'Thông báo',
                          message: 'Đã xóa'
                      );
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
              IconButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async{
                  final mood = await ref.read(moodDaoProvider).getMoodByDate(h.date);
                  if(mood != null){
                    final lockMood = await AppSecurityStorage.isMoodLockEnabled();
                    if(lockMood && !AppSecurityStorage.hasUnlockedMoodOnce)
                    {
                      final unLocked = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (_) => PinAuthScreen(type: AuthType.mood)),
                      );
                      if(unLocked == true){
                        Navigator.pushNamed(context, '/mood-view',arguments: mood);
                      }
                    }
                    else{
                      Navigator.pushNamed(context, '/mood-view',arguments: mood);
                    }
                  }
                  else{
                    CustomDialog.showMessageDialog(
                        context: context,
                        title: 'Thông báo',
                        message: 'Không tìm thấy nhật ký trong ngày ${h.date}'
                    );
                  }
                },
                icon: const Icon(Icons.menu_book_rounded),
              ),
              IconButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/habit-status-detail',arguments: h.date);
                },
                icon: const Icon(Icons.remove_red_eye),
              ),
            ],
          )
        ],
      ),
    );
  }
  
}