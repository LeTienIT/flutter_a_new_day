import 'package:a_new_day/features/habit/widget/habit_status_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../menu/menu.dart';
import '../../provider/habit_history_controller.dart';

class HabitStatusListScreen extends ConsumerWidget{
  const HabitStatusListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách'),),
      drawer: Drawer(child: Menu(),),
      body: state.when(
          data: (list) => ListView.builder(
              itemCount: list.length,
              itemBuilder: (_,idx){
                final item = list[idx];
                return HabitStatusItem(h: item);
              }
          ),
          error: (err,_) => Center(child: Text("Lỗi: $err"),),
          loading: () => const Center(child: CircularProgressIndicator(),)),
    );
  }

}