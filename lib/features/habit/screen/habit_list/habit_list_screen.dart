import 'package:a_new_day/features/habit/provider/habit_list_controller.dart';
import 'package:a_new_day/features/habit/provider/habit_state.dart';
import 'package:a_new_day/features/habit/widget/habit_item.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/show_dialog.dart';

class HabitListScreen extends ConsumerWidget{
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitListProvider);
    final controller = ref.watch(habitListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Danh sách thói quen'),),
      drawer: Drawer(child: Menu(),),
      body: switch(state){
        HabitListLoading() => const Center(child: const CircularProgressIndicator(),),
        HabitListError(:final message) => Center(child: Text('Error: $message')),
        HabitListData(: final listData, : final activeItemId) => ListView.builder(
          itemCount: listData.length,
          itemBuilder: (_, idx){
            final item = listData[idx];
            return HabitItem(
                h: item,
                isActive: activeItemId == item.id!,
                onTap: (){
                  controller.setActiveItem(
                      controller.isActive(item.id!) ? null : item.id!
                  );
                },
                onView: (){},
                onEdit: (){
                  Navigator.pushNamed(context, '/habit-edit', arguments: item);
                },
                onDelete: () async {
                  final comfirm = await CustomDialog.showConfirmDialog(
                      context: context,
                      title: 'Xác nhận xóa',
                      message: 'Bạn thật sự muốn xóa đi thói quen này\n'
                          'Điều này sẽ chỉ ảnh hưởng đến hiện tại và tương lai.\n');
                  if(comfirm) {
                    controller.deleteHabit(item);
                    await CustomDialog.showMessageDialog(
                        context: context,
                        title: 'Thông báo',
                        message: 'Nhật ký đã được xóa'
                    );
                  }
                }
            );
          },
        ),
      },
    );
  }

}