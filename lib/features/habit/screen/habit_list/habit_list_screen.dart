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
    late TextEditingController filter;
    final listFilter = ref.watch(filterHabitList);
    String? condition = ref.watch(habitCondition);
    condition != null ? filter = TextEditingController(text: condition!) : filter = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách nhiệm vụ'),),
      drawer: Drawer(child: Menu(),),
      body: switch(state){
        HabitListLoading() => const Center(child: const CircularProgressIndicator(),),
        HabitListError(:final message) => Center(child: throw('Error: $message')),
        HabitListData(: final listData, : final activeItemId) => Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: filter,
                    onSubmitted: (value) {
                      ref.read(habitCondition.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tên',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          filter.clear();
                          ref.read(habitCondition.notifier).state = null;
                        },
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(habitCondition.notifier).state = filter.text;
                  },
                  icon: Icon(Icons.search),
                  label: Text("Lọc"),
                ),
              ],
            ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listFilter.length,
                itemBuilder: (_, idx){
                  final item = listFilter[idx];
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
                            message: 'Bạn thật sự muốn xóa đi nhiệm vụ này\n'
                                'Điều này sẽ chỉ ảnh hưởng đến hiện tại và tương lai.\n');
                        if(comfirm) {
                          await controller.deleteHabit(item);
                          await CustomDialog.showMessageDialog(
                              context: context,
                              title: 'Thông báo',
                              message: 'Đã xóa'
                          );
                        }
                      }
                  );
                },
              ),
            )
          ],
        )
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/habit-add'),
        child: Icon(Icons.add_box_outlined),),
    );
  }

}