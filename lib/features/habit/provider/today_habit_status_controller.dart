
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/dao/habit_dao.dart';
import '../../../data/database/providers/database_providers.dart';
import '../../../data/models/habit_model.dart';
import '../../../data/models/habit_status_model.dart';
import 'habit_history_controller.dart';
import 'habit_list_controller.dart';
import 'habit_state.dart';

final todayHabitStatusProvider = AsyncNotifierProvider<TodayHabitStatusNotifier, List<HabitStatusModel>>(
    TodayHabitStatusNotifier.new
);

class TodayHabitStatusNotifier extends AsyncNotifier<List<HabitStatusModel>> {
  late final HabitDAO dao;

  @override
  Future<List<HabitStatusModel>> build() async {
    dao = ref.read(habitDaoProvider);

    final habitListNotifier = ref.read(habitListProvider.notifier);
    final allHabits = await habitListNotifier.getHabits();
    await _generateTodayStatuses(allHabits);
    return await dao.getHabitStatusesByDate(DateTime.now());
  }

  Future<void> _generateTodayStatuses(List<HabitModel> habits) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final weekday = today.weekday;

    for (final habit in habits) {
          if (!habit.repeatDays.contains(weekday)) continue;

          final exists = await dao.isExist(habit.id!, todayDate);
          if (!exists) {
            final s = HabitStatusModel(
              habitId: habit.id!,
              habitTitle: habit.name,
              date: todayDate,
              completed: false,
            );
            await dao.insertHabitStatus(s);
      }
    }
  }

  Future<void> updateStatus(HabitStatusModel newStatus) async {
    await dao.updateHabitStatus(newStatus);

    final current = state.value;
    if (current == null) return;

    final updated = [
      for (final s in current)
        if (s.id == newStatus.id) newStatus else s,
    ];
    ref.read(habitHistoryProvider.notifier).reloadAll();
    state = AsyncData(updated);
  }
}

