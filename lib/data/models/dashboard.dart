class HabitDaySummary {
  final DateTime date;
  final int total;
  final int completed;
  final double percent;

  HabitDaySummary({
    required this.date,
    required this.total,
    required this.completed,
  }) : percent = total == 0 ? 0 : completed / total * 100;
}

class HabitCompletionRate {
  final String title;
  final double rate;
  final int total;

  HabitCompletionRate({required this.title, required this.rate, required this.total});
}

class HabitCountStat {
  final String title;
  final int count;

  HabitCountStat({required this.title, required this.count});
}

class DashboardMain {
  final List<HabitDaySummary> daySummaries;
  final List<HabitCompletionRate> completionRates;
  final List<HabitCountStat> usageStats;
  final List<String> deletedHabitTitles;
  List<MoodEnergyPoint> moodEnergyPoint;

  DashboardMain({
    required this.daySummaries,
    required this.completionRates,
    required this.usageStats,
    required this.deletedHabitTitles,
    required this.moodEnergyPoint
  });

  factory DashboardMain.empty() => DashboardMain(
      daySummaries: [],
      completionRates: [],
      usageStats: [],
      deletedHabitTitles: [],
      moodEnergyPoint: []
  );
}

class HabitDoubleStat {
  final String title;
  final int count;
  final double percent;

  HabitDoubleStat({
    required this.title,
    required this.count,
    required this.percent,
  });
}

class MoodEnergyPoint {
  final DateTime date;
  final String emojiPath;
  final int nangLuong;

  MoodEnergyPoint({required this.date, required this.emojiPath, required this.nangLuong});
}