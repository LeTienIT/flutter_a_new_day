import 'dart:io';
import 'package:a_new_day/core/utils/tool.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/database/providers/database_providers.dart';
import '../../../../data/models/habit_model.dart';
import '../../../../data/models/habit_status_model.dart';
import '../../provider/habit_list_controller.dart';
import '../../provider/habit_state.dart';

class HabitStatusDetailScreen extends ConsumerWidget{
  final DateTime date;

  const HabitStatusDetailScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitState = ref.watch(habitListProvider);
    if (habitState is! HabitListData ) {
      return const Center(child: CircularProgressIndicator());
    }
    final habits = habitState.listData;
    final dao = ref.read(habitDaoProvider);
    return FutureBuilder<List<HabitStatusModel>>(
      future: dao.getHabitStatusesByDate(date),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final statuses = snapshot.data!;
        final completed = statuses.where((s) => s.completed).length;
        final total = statuses.length;
        final percent = (completed / total * 100).toStringAsFixed(0);
        return Scaffold(
          appBar: AppBar(title: Text(formatVietnameseDate(date))),
          body: statuses.isEmpty
              ? const Center(child: Text("Không có dữ liệu cho ngày này")) :
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text("🎯 $completed / $total ($percent%) hoàn thành"),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: status.completed
                            ? Colors.green[200]
                            : Colors.orange[300],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
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
                                ? FileImage(File(iconPath))
                                : null,
                            child: iconPath == null
                                ? const Icon(Icons.insert_emoticon_outlined)
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
                          Text(
                            status.completed ? '✔️' : '❌',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ],
            ),
        );
      },
    );
  }

}