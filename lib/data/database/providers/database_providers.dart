import 'package:a_new_day/data/database/dao/emoji_dao.dart';
import 'package:riverpod/riverpod.dart';
import '../app_database.dart';
import '../dao/file_icon_dao.dart';
import '../dao/habit_dao.dart';
import '../dao/mood_dao.dart';
import '../dao/setting_dao.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final moodDaoProvider = Provider<MoodDAO>((ref) {
  return ref.watch(appDatabaseProvider).moodDao;
});

// Các DAO khác nếu có
final habitDaoProvider = Provider<HabitDAO>((ref) {
  return ref.watch(appDatabaseProvider).habitDao;
});

// Các DAO khác nếu có
final emojiDaoProvider = Provider<EmojiDAO>((ref) {
  return ref.watch(appDatabaseProvider).emojiDao;
});

final settingDaoProvider = Provider<SettingDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.settingDao;
});

final fileIconDaoProvider = Provider<FileIconDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.fileIconDao;
});