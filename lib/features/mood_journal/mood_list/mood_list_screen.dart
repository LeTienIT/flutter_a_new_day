import 'package:a_new_day/core/utils/show_dialog.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:a_new_day/features/mood_journal/mood_widget/mood_item.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'mood_list_state.dart';

class MoodListScreen extends ConsumerWidget{
  const MoodListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moodListProvider);
    final controller = ref.watch(moodListProvider.notifier);
    // MoodModel m = MoodModel(date: DateTime.now(), emoji: 'I-LOVE-YOU');
    // controller.insertMood(m);

    final filter = ref.watch(moodFilterProvider);
    final filteredList = ref.watch(filteredMoodListProvider); // Thay vì state.listData

    return Scaffold(
      appBar: AppBar(title: Text('Nhật ký mỗi ngày'),),
      drawer: Drawer(child: Menu(),),
      body: switch(state){
        MoodListLoading() => const Center(child: CircularProgressIndicator()),
        MoodListData(:final listData, :final activeItemId) => Column(
          children: [
            Wrap(
              spacing: 10,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(filter != null
                    ? 'Ngày: ${DateFormat.yMd().format(filter)}'
                    : 'Lọc?'),
                ElevatedButton.icon(
                    onPressed: ()async{
                      final rs = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2002),
                          lastDate: DateTime.now(),
                          initialDate:  DateTime.now()
                      );
                      if(rs!=null){
                        ref.read(moodFilterProvider.notifier).state = rs;
                      }
                    },
                    label: Icon(Icons.date_range_sharp)
                ),
                IconButton(
                    onPressed: (){ ref.read(moodFilterProvider.notifier).state = null;},
                    icon: Icon(Icons.clear)
                )
              ],
            ),
            Expanded(
                child:ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (_, idx){
                    final item = listData[idx];
                    return MoodItem(
                        mood: item,
                        isActive: activeItemId == item.id,
                        onTap: (){
                          controller.setActiveItem(
                              controller.isActive(item.id!) ? null : item.id!
                          );
                        },
                        onView: (){Navigator.pushNamed(context, '/mood-view', arguments: item);},
                        onEdit: (){Navigator.pushNamed(context, '/mood-edit', arguments: item);},
                        onDelete: ()async{
                          final comfirm = await CustomDialog.showConfirmDialog(
                              context: context,
                              title: 'Xác nhận xóa',
                              message: 'Bạn thật sự muốn xóa đi ngày nhật ký này\n'
                                  'Điều này sẽ xoá tất cả nhưng gì bạn đã tạo về nhật ký này.\n'
                                  'Và bạn sẽ không thể: THÊM LẠI NHẬT KÝ CỦA NGÀY NÀY NỮA - NẾU ĐÓ LÀ QUÁ KHỨ\n\n'
                                  '(Kiến nghị) Nếu có chỗ chưa hợp có thể chỉnh sửa');
                          if(comfirm) {
                            controller.deleteMood(item);
                            await CustomDialog.showMessageDialog(
                                context: context,
                                title: 'Thông báo',
                                message: 'Nhật ký đã được xóa'
                            );
                          }
                        }
                    );
                  },
                )
            ),
          ],
        ),
        MoodListError(:final message) => Center(child: Text('Error: $message')),
      },
    );
  }

}