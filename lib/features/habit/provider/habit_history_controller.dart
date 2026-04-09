import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/dao/habit_dao.dart';
import '../../../data/database/providers/database_providers.dart';
import '../../../data/models/habit_status_model.dart';

final filterYearProvider = StateProvider<int?>((ref) => null);
final filterMonthProvider = StateProvider<int?>((ref) => null);
final filterDayProvider = StateProvider<int?>((ref) => null);

final filteredHabitHistoryProvider = Provider<List<HabitStatusModel>>((ref) {
  final asyncState = ref.watch(habitHistoryProvider);

  final year = ref.watch(filterYearProvider);
  final month = ref.watch(filterMonthProvider);
  final day = ref.watch(filterDayProvider);

  if (!asyncState.hasValue) return [];

  final data = asyncState.value!;
  final now = DateTime.now();

  return data.where((e) {
    final d = e.date;

    /// ❗ KHÔNG chọn gì → show all
    if (year == null && month == null && day == null) {
      return true;
    }

    /// chỉ chọn năm
    if (year != null && month == null && day == null) {
      return d.year == year;
    }

    /// năm + tháng
    if (year != null && month != null && day == null) {
      return d.year == year && d.month == month;
    }

    /// full
    if (year != null && month != null && day != null) {
      return d.year == year &&
          d.month == month &&
          d.day == day;
    }

    /// tháng thôi → dùng năm hiện tại
    if (year == null && month != null && day == null) {
      return d.year == now.year && d.month == month;
    }

    /// ngày thôi
    if (year == null && month == null && day != null) {
      return d.year == now.year &&
          d.month == now.month &&
          d.day == day;
    }

    /// tháng + ngày
    if (year == null && month != null && day != null) {
      return d.year == now.year &&
          d.month == month &&
          d.day == day;
    }

    return true;
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

