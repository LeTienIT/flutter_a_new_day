import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/dao/habit_dao.dart';
import '../../../data/database/providers/database_providers.dart';
import '../../../data/models/habit_status_model.dart';

final habitHistoryProvider = AsyncNotifierProvider<HabitHistoryNotifier, List<HabitStatusModel>>(
  HabitHistoryNotifier.new,
);

class HabitHistoryNotifier extends AsyncNotifier<List<HabitStatusModel>> {
  late final HabitDAO dao;
  late List<HabitStatusModel> _listGoc;

  @override
  Future<List<HabitStatusModel>> build() async {
    dao = ref.read(habitDaoProvider);
    _listGoc = await dao.getAllHabitStatuses();
    return getOneStatusPerDay(_listGoc);
  }

  void filterByDateRange(DateTime start, DateTime end) {
    final filtered = _listGoc.where((s) {
      return s.date.isAfter(start.subtract(const Duration(days: 1))) &&
          s.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();

    state = AsyncData(getOneStatusPerDay(filtered));
  }

  Future<void> reloadAll() async {
    state = const AsyncLoading();
    _listGoc = await dao.getAllHabitStatuses();
    state = AsyncData(getOneStatusPerDay(_listGoc));
  }

  List<HabitStatusModel> getOneStatusPerDay(List<HabitStatusModel> allStatuses) {
    final Map<String, List<HabitStatusModel>> grouped = {};

    for (final status in allStatuses) {
      final key = "${status.date.year}-${status.date.month}-${status.date.day}";
      grouped.putIfAbsent(key, () => []).add(status);
    }

    final List<HabitStatusModel> result = [];

    grouped.forEach((key, statusList) {
      final first = statusList.first;

      final allCompleted = statusList.every((s) => s.completed);

      result.add(
        HabitStatusModel(
          id: first.id,
          habitId: first.habitId,
          habitTitle: first.habitTitle,
          date: DateTime(first.date.year, first.date.month, first.date.day),
          completed: allCompleted,
        ),
      );
    });

    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

}

