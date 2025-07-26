import 'dart:io';

import 'package:a_new_day/data/models/habit_status_model.dart';
import 'package:a_new_day/features/habit/provider/today_habit_status_controller.dart';
import 'package:a_new_day/features/menu/menu.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/database/providers/database_providers.dart';
import '../../provider/habit_list_controller.dart';
import '../../provider/habit_state.dart';

class HomeHabitScreen extends ConsumerStatefulWidget{
  const HomeHabitScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeHabitScreen();
  }
}
class _HomeHabitScreen extends ConsumerState<HomeHabitScreen>{
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final habitState = ref.watch(habitListProvider);
    final statusState = ref.watch(todayHabitStatusProvider);

    final isHabitLoaded = habitState is HabitListData;
    final isStatusLoaded = !statusState.isLoading;

    if (!isHabitLoaded || !isStatusLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final habits = (habitState as HabitListData).listData;
    final statuses = statusState.value!;

    final completed = statuses.where((s) => s.completed).length;
    final total = statuses.length;
    final percent = (completed / total * 100).toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(title: Text('Hôm nay bạn thế nào'),),
      drawer: Drawer(child: Menu(),),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Text("🎯 Hôm nay: $completed / $total ($percent%) hoàn thành"),
          ),
          Expanded(child: ListView.builder(
            itemCount: statuses.length,
            itemBuilder: (context, index) {
              final status = statuses[index];
              final habit = habits.firstWhereOrNull((h) => h.id == status.habitId);
              String? iconPath;
              if(habit != null){
                iconPath = habit.icon?.isNotEmpty == true ? habit.icon : null;
              }
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: status.completed
                      ? Colors.green[400]
                      : Colors.orange[400],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: iconPath != null
                          ? FileImage(File(iconPath!))
                          : null,
                      child: iconPath == null
                          ? const Icon(Icons.insert_emoticon_outlined, size: 28)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    if(habit==null)...[
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: status.habitTitle),
                              TextSpan(
                                text: "\n(Đã bị xóa)",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                    else if(habit != null && habit.name != status.habitTitle)...[
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: status.habitTitle),
                              TextSpan(
                                text: "\n(Đổi tên: ${habit.name})",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                    else
                      Expanded(
                        child: Text(
                          habit.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    Checkbox(
                      value: status.completed,
                      onChanged: (value) async {
                        final newStatus = HabitStatusModel(
                            id: status.id,
                            completed: value ?? false,
                            habitId: status.habitId,
                            habitTitle: status.habitTitle,
                            date: status.date
                        );
                        await ref.read(todayHabitStatusProvider.notifier).updateStatus(newStatus);
                      },
                    ),
                  ],
                ),
              );
            },
          ),),
        ],
      )
    );
  }

}