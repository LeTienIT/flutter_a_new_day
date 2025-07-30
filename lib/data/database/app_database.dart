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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _insertDefaultEmojis();
    },
    onUpgrade: (m, from, to) async {
      if (from == 1) {
        await m.addColumn(moods, moods.video);
      }
      if (from <= 2) {
        await m.addColumn(emojiTable, emojiTable.nangLuong);
        await delete(emojiTable).go();
        await _insertDefaultEmojis();
      }
    },
  );

  late final habitDao = HabitDAO(this);
  late final moodDao = MoodDAO(this);
  late final emojiDao = EmojiDAO(this);

  Future<void> _insertDefaultEmojis() async {
    await batch((batch) {
      batch.insertAll(
        emojiTable,
        [
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/angry-face.png',
            name: 'Tức giận quá, tực giận quá',
            enable: const Value(false),
            nangLuong: const Value(2),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/love.png',
            name: 'Cuộc đời thật là tười đẹp - hì hì',
            enable: const Value(false),
            nangLuong: const Value(9),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/neutral.png',
            name: 'Ồ! Lại một ngày bình thường',
            enable: const Value(false),
            nangLuong: const Value(5),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/sad.png',
            name: 'Hôm nay tôi buồn -_-',
            enable: const Value(false),
            nangLuong: const Value(3),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/vo_tri.png',
            name: 'Hì hì - Lại một ngày zô tri zô tri',
            enable: const Value(false),
            nangLuong: const Value(2),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/yeu_yeu.png',
            name: 'Người yêu ơi có biết ...',
            enable: const Value(false),
            nangLuong: const Value(8),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/happy.png',
            name: 'Một ngày thật hạnh phúc - Zui Zui ^_^',
            enable: const Value(false),
            nangLuong: const Value(10),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/excited.png',
            name: 'AMAZING GOOD CHOP - Rất là phấn khích',
            enable: const Value(false),
            nangLuong: const Value(9),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/thanks.png',
            name: 'Xin cảm ơn!',
            enable: const Value(false),
            nangLuong: const Value(8),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/relaxed.png',
            name: 'Thư giãn, thư gian, thả lỏng nào',
            enable: const Value(false),
            nangLuong: const Value(7),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/smiley.png',
            name: 'Ố ồ Ô. Mình hôm nay thật ... - Quá là tự tin luôn',
            enable: const Value(false),
            nangLuong: const Value(8),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/positivity.png',
            name: 'Vui tươi - Zui zẻ - Lạc quan',
            enable: const Value(false),
            nangLuong: const Value(9),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/sloth.png',
            name: 'Có cảm giác nay thật lười biếng!',
            enable: const Value(false),
            nangLuong: const Value(2),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/cartoon.png',
            name: 'Thờ ờ, thờ ơ mọi thứ',
            enable: const Value(false),
            nangLuong: const Value(3),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/confused.png',
            name: 'Khá là "Bối rối" - phân vân',
            enable: const Value(false),
            nangLuong: const Value(4),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/stress.png',
            name: 'Thật là căng thẳng quá đi à.',
            enable: const Value(false),
            nangLuong: const Value(2),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/shocked.png',
            name: 'Lo lắng - lo lắng - sao? Lo lắng!',
            enable: const Value(false),
            nangLuong: const Value(3),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/alone.png',
            name: 'Alone - tôi đang một mình.',
            enable: const Value(false),
            nangLuong: const Value(2),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/tired.png',
            name: 'Một ngày mệt mỏi - RẤT MỆT MỎI!',
            enable: const Value(false),
            nangLuong: const Value(1),
          ),
          EmojiTableCompanion.insert(
            path: 'assets/emoji_default/overthinking.png',
            name: 'Thật sự có chút nhút nhát - hay do suy nghĩ nhiều nhỉ?',
            enable: const Value(false),
            nangLuong: const Value(3),
          ),
        ],
      );
    });
  }

}

// Hàm kết nối phải để ngoài
LazyDatabase _openConnect() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'a_new_day.db'));
    return NativeDatabase(file);
  });
}
