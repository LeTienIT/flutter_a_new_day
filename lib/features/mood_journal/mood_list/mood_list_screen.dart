import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_item.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'mood_list_state.dart';

class MoodListScreen extends ConsumerWidget{
  const MoodListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moodListProvider);
    final controller = ref.watch(moodListProvider.notifier);
    // MoodModel m = MoodModel(date: DateTime.now(), emoji: 'I-LOVE-YOU');
    // controller.insertMood(m);
    return Scaffold(
      appBar: AppBar(title: Text('Nhật ký mỗi ngày'),),
      drawer: Drawer(child: Menu(),),
      body: switch(state){
        MoodListLoading() => const Center(child: CircularProgressIndicator()),
        MoodListData(:final listData, :final activeItemId) => ListView.builder(
          itemCount: listData.length,
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
                onView: (){},
                onEdit: (){},
                onDelete: (){}
            );
          },
        ),
        MoodListError(:final message) => Center(child: Text('Error: $message')),
      },
    );
  }

}