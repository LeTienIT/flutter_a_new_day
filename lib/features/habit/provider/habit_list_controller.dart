import 'dart:io';

import 'package:a_new_day/data/database/dao/habit_dao.dart';
import 'package:a_new_day/data/database/providers/database_providers.dart';
import 'package:a_new_day/data/models/habit_model.dart';
import 'package:a_new_day/features/habit/provider/habit_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/image_utils.dart';
import '../../../data/models/habit_status_model.dart';
import 'habit_history_controller.dart';

final habitCondition = StateProvider<String?>((ref) => null);
final filterHabitList = StateProvider<List<HabitModel>>(
    (ref){
      final habitP = ref.watch(habitListProvider);
      final habitCon = ref.watch(habitCondition);

      if(habitP is! HabitListData) return [];
      if(habitCon == null) return habitP.listData;

      final rs = habitP.listData.where((h) =>
          h.name.toLowerCase().contains(habitCon.toLowerCase())
      ).toList();

      return rs;
    }
);

final habitListProvider = NotifierProvider<HabitListNotifier, HabitListState>(
    HabitListNotifier.new
);

class HabitListNotifier extends Notifier<HabitListState>{
  late final HabitDAO habitDAO;
  final ImageUtils _imageUtil = ImageUtils();

  @override
  HabitListState build() {
    habitDAO = ref.read(habitDaoProvider);
    Future.microtask(() => _loadData());
    return HabitListLoading();
  }

  Future<void> _loadData() async {
    try{
      state = HabitListLoading();
      final data = await habitDAO.getAllHabit();
      // await _generateTodayStatuses(data);
      state = HabitListData(data);
    }catch(e){
      state = HabitListError(e.toString());
    }
  }

  Future<void> refresh() async => _loadData();

  Future<void> _refreshData() async {
    try{
      state = HabitListLoading();
      final data = await habitDAO.getAllHabit();
      // print("Data: $data");
      state = HabitListData(data);
    }catch(e){
      state = HabitListError(e.toString());
    }
  }

  Future<List<HabitModel>> getHabits() async {
    if (state is HabitListData) {
      return (state as HabitListData).listData;
    } else {
      try {
        final habits = await habitDAO.getAllHabit();
        state = HabitListData(habits);
        return habits;
      } catch (e) {
        state = HabitListError(e.toString());
        return [];
      }
    }
  }

  void setActiveItem(int? id) {
    final currentState = state;
    if (currentState is HabitListData) {
      state = HabitListData(
        currentState.listData,
        activeItemId: id,
      );
    }
  }

  bool isActive(int id) {
    return state.activeItemId == id;
  }

  bool checkName(String name) {
    final currentState = state;
    if (currentState is HabitListData) {
      final normalizedName = name.trim().toLowerCase();
      return currentState.listData.any(
            (habit) => habit.name.trim().toLowerCase() == normalizedName,
      );
    }
    return true;
  }

  bool isHabitForToday(HabitModel habit) {
    final today = DateTime.now().weekday;
    return habit.repeatDays.contains(today);
  }

  Future<void> insertHabit(HabitModel h) async {
    try {
      if (h.icon?.isNotEmpty == true) {
        final original = File(h.icon!);
        final saved = await _imageUtil.compressAndSaveIcon(original);
        if (saved != null) {
          h.icon = saved.path;
        }
      }
      int id = await habitDAO.insertHabit(h);

      if (isHabitForToday(h)) {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final habitStatus = HabitStatusModel(
          habitId: id,
          habitTitle: h.name,
          date: todayDate,
          completed: false,
        );
        await habitDAO.insertHabitStatus(habitStatus);
      }

      await _refreshData();
      await ref.read(habitHistoryProvider.notifier).reloadAll();
    } catch (e) {
      state = HabitListError(e.toString());
    }
  }

  Future<void> updateHabit(HabitModel hLast, HabitModel hNew) async {
    try {
      final oldIcon = hLast.icon;
      final newIcon = hNew.icon;

      if (oldIcon != newIcon) {
        if (oldIcon?.isNotEmpty == true) {
          await _imageUtil.deleteFile(oldIcon!);
        }
        if (newIcon?.isNotEmpty == true) {
          final original = File(newIcon!);
          final saved = await _imageUtil.compressAndSaveIcon(original);
          if (saved != null) {
            hNew.icon = saved.path;
          }
        }
      }

      await habitDAO.updateHabit(hNew);
      final isToday = isHabitForToday(hNew);
      if (isToday) {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final existing = await habitDAO.getHabitStatus(hNew.id!, todayDate);
        if (existing == null) {
          final status = HabitStatusModel(
            id: null,
            habitId: hNew.id!,
            habitTitle: hNew.name,
            date: todayDate,
            completed: false,
          );
          await habitDAO.insertHabitStatus(status);
        } else if (existing.habitTitle != hNew.name) {
          await habitDAO.updateHabitStatus(existing);
        }
      }
      await _loadData();
      await ref.read(habitHistoryProvider.notifier).reloadAll();
    } catch (e) {
      state = HabitListError(e.toString());
    }
  }

  Future<void> deleteHabit(HabitModel h) async {
    try {
      if (h.icon?.isNotEmpty == true ) {
        await _imageUtil.deleteFile(h.icon!);
      }

      final today = DateTime.now();
      final start = DateTime(today.year, today.month, today.day);
      final end = start.add(const Duration(days: 1));

      await habitDAO.deleteStatusesToday(h.id!, start, end);

      await habitDAO.deleteHabit(h.id!);
      await _loadData();
      await ref.read(habitHistoryProvider.notifier).reloadAll();
    } catch (e) {
      state = HabitListError(e.toString());
    }
  }

  Future<void> _generateTodayStatuses(List<HabitModel> habits) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final weekday = today.weekday;

    for (final habit in habits) {
      if (!habit.repeatDays.contains(weekday)) continue;

      final isExist = await habitDAO.isExist(habit.id!, todayDate);
      if (!isExist) {
        final status = HabitStatusModel(
          habitId: habit.id!,
          habitTitle: habit.name,
          date: todayDate,
          completed: false,
        );

        await habitDAO.insertHabitStatus(status);
      }
    }
    await _refreshData();
  }

  Future<void> generateTodayStatuses(List<HabitModel> habits) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day); // bỏ giờ phút giây
    final weekday = today.weekday; // từ 1 (T2) đến 7 (CN)

    for (final habit in habits) {
      if (!habit.repeatDays.contains(weekday)) continue; // bỏ qua nếu hôm nay không nằm trong repeat

      final isExist = await habitDAO.isExist(habit.id!, todayDate); // check đã tạo HabitStatus chưa
      if (!isExist) {
        final status = HabitStatusModel(
          habitId: habit.id!,
          habitTitle: habit.name,
          date: todayDate,
          completed: false,
        );

        await habitDAO.insertHabitStatus(status); // tạo mới
      }
    }
  }
}