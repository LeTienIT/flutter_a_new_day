import 'dart:async';
import 'dart:ui' as ui;

import 'package:a_new_day/data/models/dashboard.dart';
import 'package:a_new_day/data/models/emoji_model.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:a_new_day/features/habit/provider/habit_history_controller.dart';
import 'package:a_new_day/features/habit/provider/habit_list_controller.dart';
import 'package:a_new_day/features/mood_journal/mood_list/mood_list_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/habit_model.dart';
import '../../data/models/habit_status_model.dart';
import '../habit/provider/habit_state.dart';
import '../mood_journal/emoji_repository.dart';
import '../mood_journal/mood_list/mood_list_controller.dart';

final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardMain>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardMain>{
  @override
  FutureOr<DashboardMain> build() async {
    final habitListState = ref.watch(habitListProvider);
    final asyncState = ref.watch(habitHistoryProvider);
    final emojiAsync = ref.watch(emojisNotifierProvider);
    final moodProvider = ref.watch(moodListProvider);

    if (!asyncState.hasValue || !emojiAsync.hasValue) return DashboardMain.empty();

    final raw = ref.read(habitHistoryProvider.notifier).rawList;

    final currentHabits = switch (habitListState) {
      HabitListData(:final listData) => listData,
      _ => <HabitModel>[],
    };
    final listMood = switch (moodProvider) {
      MoodListData(:final listData) => listData,
      _ => <MoodModel>[],
    };
    final emojiList = emojiAsync.value ?? [];

    return _calculateStats(currentHabits, raw, listMood, emojiList);
  }


  DashboardMain _calculateStats(List<HabitModel> habits, List<HabitStatusModel> statuses,List<MoodModel> moodList, List<EmojiModel> emojiList,) {
    final daySummaries = _getStatusSummaryPerDay(statuses);
    final completionRates = _getHabitCompletionRates(statuses);
    final usageStats = _getHabitUsageStats(statuses);
    final deleted = _getDeletedHabits(statuses, habits);
    final moodListPoint = _getListMoodPoin(moodList, emojiList);
    return DashboardMain(
      daySummaries: daySummaries,
      completionRates: completionRates,
      usageStats: usageStats,
      deletedHabitTitles: deleted,
      moodEnergyPoint: moodListPoint
    );
  }

  ///Danh sách ngày + tổng công việc + số đã hoàn thành
  List<HabitDaySummary> _getStatusSummaryPerDay(List<HabitStatusModel> all) {
    //Tạo group gồm Ngày + Danh sách các HabitStatus của ngày hôm đó.
    final Map<String, List<HabitStatusModel>> grouped = {};
    for (final s in all) {
      final key = "${s.date.year}-${s.date.month}-${s.date.day}";
      grouped.putIfAbsent(key, () => []).add(s);
    }
    //Từ danh sách trên ta lấy ra mỗi ngày và danh sách, tạo danh sách ngày + công việc + số hoàn thành
    final List<HabitDaySummary> result = [];
    grouped.forEach((_, list) {
      final date = DateTime(list.first.date.year, list.first.date.month, list.first.date.day);
      final total = list.length;
      final completed = list.where((s) => s.completed).length;
      result.add(HabitDaySummary(date: date, total: total, completed: completed));
    });

    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  ///Danh sách các habit - được lấy từ habitStatus - % hoàn thành của các habit
  List<HabitCompletionRate> _getHabitCompletionRates(List<HabitStatusModel> all) {
    final Map<String, List<HabitStatusModel>> grouped = {};
    for (final s in all) {
      grouped.putIfAbsent(s.habitTitle, () => []).add(s);
    }

    final List<HabitCompletionRate> result = [];
    grouped.forEach((title, list) {
      final total = list.length;
      final completed = list.where((s) => s.completed).length;
      final double rate = (total == 0) ? 0 : (completed / total);
      print("rate: $rate");
      result.add(HabitCompletionRate(title: title, rate: rate, total: total));
    });

    result.sort((a, b) => b.rate.compareTo(a.rate));
    return result;
  }

  ///Danh sách các habit và số lần sử dụng - Tức là habit nào thường xuyên được tạo - Ngày nào cũng làm
  List<HabitCountStat> _getHabitUsageStats(List<HabitStatusModel> all) {
    final Map<String, int> counts = {};
    for (final s in all) {
      counts[s.habitTitle] = (counts[s.habitTitle] ?? 0) + 1;
    }

    final result = counts.entries
        .map((e) => HabitCountStat(title: e.key, count: e.value))
        .toList();

    result.sort((a, b) => b.count.compareTo(a.count));
    return result;
  }

  ///Danh sách các habit đã bị xóa ở hiện tại, nhưng quá khứ đã có
  List<String> _getDeletedHabits(List<HabitStatusModel> statuses, List<HabitModel> habits) {
    final currentNames = habits.map((h) => h.name).toSet();
    final allTitles = statuses.map((s) => s.habitTitle).toSet();
    return allTitles.difference(currentNames).toList();
  }

  ///Ghép 2 mảng habit+số lần dùng và habit + tỉ lệ hoàn thành thành 1 cặp -> biểu đồ cột kép
  List<HabitDoubleStat> mergeUsageAndCompletion(List<HabitCountStat> usageStats, List<HabitCompletionRate> completionRates,) {
    final Map<String, int> countMap = {
      for (final stat in usageStats) stat.title: stat.count,
    };

    final Map<String, double> percentMap = {
      for (final stat in completionRates) stat.title: stat.rate,
    };

    final Set<String> allTitles = {...countMap.keys, ...percentMap.keys};

    return allTitles.map((title) {
      final count = countMap[title] ?? 0;
      final percent = percentMap[title] ?? 0;
      return HabitDoubleStat(title: title, count: count, percent: percent);
    }).toList();
  }

  ///Tạo danh sách các điểm vẽ biểu đồ đường (9 điểm)
  List<MoodEnergyPoint> _getListMoodPoin(List<MoodModel> moodList, List<EmojiModel> emojiList){
    final List<MoodEnergyPoint> moodEnergyPoints = [];
    for (final mood in moodList) {
      final parts = mood.emoji.split('|');
      final imagePath = parts.first.trim();
      final emoji = emojiList.firstWhereOrNull(
            (e) => e.path == imagePath,
      );

      if (emoji != null) {
        moodEnergyPoints.add(
          MoodEnergyPoint(
            date: mood.date,
            emojiPath: imagePath,
            nangLuong: emoji.nangLuong,
          ),
        );
      }
    }

    return moodEnergyPoints.take(8).toList();
  }
}

final imageCacheProvider = StateNotifierProvider<ImageCacheNotifier, Map<String, ui.Image>>((ref) {
  return ImageCacheNotifier();
});

class ImageCacheNotifier extends StateNotifier<Map<String, ui.Image>> {
  ImageCacheNotifier() : super({});

  final Set<String> _loading = {};

  Future<void> loadImage(String path) async {
    if (state.containsKey(path) || _loading.contains(path)) return;

    _loading.add(path);

    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();

    state = {...state, path: frame.image};

    _loading.remove(path);
  }
}