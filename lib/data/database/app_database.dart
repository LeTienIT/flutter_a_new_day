import 'dart:io';
import 'package:a_new_day/data/database/dao/emoji_dao.dart';
import 'package:a_new_day/data/database/tables/emoji_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'dao/mood_dao.dart';
import 'tables/habit_table.dart';
import 'tables/habit_status_table.dart';
import 'tables/mood_table.dart';
import 'dao/habit_dao.dart'; // nếu có DAO

part 'app_database.g.dart'; // Phải có để Drift sinh mã

@DriftDatabase(
  tables: [Habits, HabitStatus, Moods, EmojiTable],
  daos: [HabitDAO, MoodDAO]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnect());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await batch((batch) {
        batch.insertAll(
          emojiTable,
          [
            EmojiTableCompanion.insert(path: 'assets/emoji_default/angry.png', name: 'tức giận', enable: const Value(false)),
            EmojiTableCompanion.insert(path: 'assets/emoji_default/angry-face.png', name: 'bực bội', enable: const Value(false)),
            EmojiTableCompanion.insert(path: 'assets/emoji_default/disappointed.png', name: 'thất vọng', enable: const Value(false)),
            EmojiTableCompanion.insert(path: 'assets/emoji_default/love.png', name: 'yêu đời', enable: const Value(false)),
            EmojiTableCompanion.insert(path: 'assets/emoji_default/mad.png', name: 'giận dữ', enable: const Value(false)),
            EmojiTableCompanion.insert(path: 'assets/emoji_default/neutral.png', name: 'Bình thường', enable: const Value(false)),
            EmojiTableCompanion.insert(path: 'assets/emoji_default/sad.png', name: 'buồn', enable: const Value(false)),
            EmojiTableCompanion.insert(path: 'assets/emoji_default/shy.png', name: 'Vui vui', enable: const Value(false)),
            EmojiTableCompanion.insert(path: 'assets/emoji_default/sleep.png', name: 'Thiếu năng lượng', enable: const Value(false)),
            EmojiTableCompanion.insert(path: 'assets/emoji_default/smile.png', name: 'vui', enable: const Value(false)),
          ],
        );
      });
    },
    onUpgrade: (m, from, to) async {
      if (from == 1) {
        await m.addColumn(moods, moods.video);
      }
    },
  );

  late final habitDao = HabitDAO(this);
  late final moodDao = MoodDAO(this);
  late final emojiDao = EmojiDAO(this);

}

// Hàm kết nối phải để ngoài
LazyDatabase _openConnect() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'a_new_day.db'));
    return NativeDatabase(file);
  });
}
