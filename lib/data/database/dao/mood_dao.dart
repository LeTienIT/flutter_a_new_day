import 'package:a_new_day/data/database/app_database.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:drift/drift.dart';
import '../tables/mood_table.dart';
import 'package:a_new_day/data/database/mappers/mood_mapper.dart';

part 'mood_dao.g.dart';

@DriftAccessor(tables: [Moods])
class MoodDAO extends DatabaseAccessor<AppDatabase> with _$MoodDAOMixin{
  MoodDAO(super.db);

  Future<List<MoodModel>> getAllMood() async{
    final data = await select(moods).get();
    return data.map((h) => h.toModel()).toList();
  }

  Future<int> insertMood(MoodModel h) async{
    return await into(moods).insert(h.toCompanion());
  }

  Future<bool> updateMood(MoodModel h) async{
    return await update(moods).replace(h.toCompanion());
  }

  Future<int> deleteMood(int id) async{
    final query = delete(moods)..where((h) => h.id.equals(id));
    return await query.go();
  }

  Future<MoodModel?> getMoodByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final query = select(moods)
      ..where((m) =>
      m.date.isBiggerOrEqualValue(start) &
      m.date.isSmallerThanValue(end)
      );

    final result = await query.getSingleOrNull();

    return result?.toModel();
  }
}
