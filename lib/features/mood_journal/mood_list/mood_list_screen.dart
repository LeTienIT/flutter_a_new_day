import 'package:a_new_day/core/utils/show_dialog.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:a_new_day/features/mood_journal/mood_widget/mood_item.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../mood_widget/mood_filter_bar.dart';
import 'mood_list_state.dart';

class MoodListScreen extends ConsumerWidget{
  const MoodListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moodListProvider);
    final controller = ref.watch(moodListProvider.notifier);

    final filteredList = ref.watch(filteredMoodListProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: Text('Nhật ký mỗi ngày'),),
        drawer: Drawer(child: Menu(),),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: Colors.white,
          overlayOpacity: 0.5,
          spacing: 4,
          spaceBetweenChildren: 4,
          overlayColor: Colors.black,

          children: [
            SpeedDialChild(
              child: const Icon(Icons.menu_book),
              label: 'Tạo sách',
              onTap: () {
                final data = filteredList.reversed.toList();
                Navigator.pushNamed(context, '/mood-book', arguments: data);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.filter_alt_off),
              label: 'Bỏ bộ lọc',
              onTap: () {
                ref.read(moodYearProvider.notifier).state = -1;
                ref.read(moodMonthProvider.notifier).state = null;
                ref.read(moodDayProvider.notifier).state = null;
              },
            ),
          ],
        ),
        body: switch(state){
          MoodListLoading() => const Center(child: CircularProgressIndicator()),
          MoodListData(:final listData, :final activeItemId) => Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: MoodFilterBar(),
              ),
              Expanded(
                  child:ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (_, idx){
                      final item = filteredList[idx];
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
      ),
    );
  }
}