import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/dao/habit_dao.dart';
import '../../../data/database/providers/database_providers.dart';
import '../../../data/models/habit_status_model.dart';

enum HabitHistoryFilterType { all, day, week, month }

final habitFilterDateProvider = StateProvider<DateTime?>((ref) => null);
final habitFilterTypeProvider = StateProvider<HabitHistoryFilterType>((ref) => HabitHistoryFilterType.all);

final filteredHabitHistoryProvider = Provider<List<HabitStatusModel>>((ref) {
  final asyncState = ref.watch(habitHistoryProvider);
  final filterDate = ref.watch(habitFilterDateProvider);
  final filterType = ref.watch(habitFilterTypeProvider);

  if (!asyncState.hasValue) return [];

  final allData = asyncState.value!;
  if (filterDate == null || filterType == HabitHistoryFilterType.all) return allData;

  return allData.where((status) {
    final d = status.date;
    final f = filterDate;

    switch (filterType) {
      case HabitHistoryFilterType.day:
        return d.year == f!.year && d.month == f.month && d.day == f.day;
      case HabitHistoryFilterType.week:
        final startOfWeek = f!.subtract(Duration(days: f.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return d.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
            d.isBefore(endOfWeek.add(const Duration(days: 1)));
      case HabitHistoryFilterType.month:
        return d.year == f!.year && d.month == f.month;
      default:
        return true;
    }
  }).toList();
});


final habitHistoryProvider = AsyncNotifierProvider<HabitHistoryNotifier, List<HabitStatusModel>>(
  HabitHistoryNotifier.new,
);

class HabitHistoryNotifier extends AsyncNotifier<List<HabitStatusModel>> {
  late final HabitDAO dao;
  late List<HabitStatusModel> _listGoc;

  List<HabitStatusModel> get rawList {
    if (_listGoc.isEmpty) {
      // throw StateError('rawList is not initialized yet');
      return [];
    }
    return _listGoc;
  }

  @override
  Future<List<HabitStatusModel>> build() async {
    dao = ref.read(habitDaoProvider);
    _listGoc = await dao.getAllHabitStatuses();
    return getOneStatusPerDay(_listGoc);
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

  Future<void> deleteHabitStatus(HabitStatusModel h) async {
    state = const AsyncLoading();
    await dao.deleteHabitStatusByDate(h.date);
    await reloadAll();
  }
}

