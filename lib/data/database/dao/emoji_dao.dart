import 'package:a_new_day/data/database/app_database.dart';
import 'package:a_new_day/data/database/mappers/emoji_mapper.dart';
import 'package:drift/drift.dart';
import '../../models/emoji_model.dart';
import '../tables/emoji_table.dart';

part 'emoji_dao.g.dart';

@DriftAccessor(tables: [EmojiTable])
class EmojiDAO extends DatabaseAccessor<AppDatabase> with _$EmojiDAOMixin{
  EmojiDAO(super.db);

  Future<List<EmojiModel>> getAllEmoji() async{
    final data = await select(emojiTable).get();
    return data.map((h) => h.toModel()).toList();
  }
  //
  Future<int> insertMood(EmojiModel h) async{
    return await into(emojiTable).insert(h.toCompanion());
  }
  //
  Future<bool> updateMood(EmojiModel h) async{
    return await update(emojiTable).replace(h.toCompanion());
  }
  //
  Future<int> deleteMood(int id) async{
    final query = delete(emojiTable)..where((h) => h.id.equals(id));
    return await query.go();
  }
}
