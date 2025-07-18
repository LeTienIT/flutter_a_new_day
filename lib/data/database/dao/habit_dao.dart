import 'package:a_new_day/data/database/app_database.dart';
import 'package:a_new_day/data/database/mappers/habit_mapper.dart';
import 'package:a_new_day/data/models/habit_model.dart';
import 'package:a_new_day/data/models/habit_status_model.dart';
import 'package:drift/drift.dart';
import '../tables/habit_status_table.dart';
import '../tables/habit_table.dart';

part 'habit_dao.g.dart';

@DriftAccessor(tables: [Habits, HabitStatus])
class HabitDAO extends DatabaseAccessor<AppDatabase> with _$HabitDAOMixin{
  HabitDAO(super.db);

  Future<List<HabitModel>> getAllHabit() async{
    final data = await select(habits).get();
    return data.map((h) => h.toModel()).toList();
  }

  Future<int> insertHabit(HabitModel h) async{
    return await into(habits).insert(h.toCompanion());
  }

  Future<bool> updateHabit(HabitModel h) async{
    return await update(habits).replace(h.toCompanion());
  }

  Future<int> deleteHabit(int id) async{
    final query = delete(habits)..where((h) => h.id.equals(id));
    return await query.go();
  }

  Future<List<HabitStatusModel>> getAllHabitStatus() async{
    final data = await select(habitStatus).get();
    return data.map((d)=>d.toModel()).toList();
  }

  Future<int> insertHabitStatus(HabitStatusModel h) async{
    return await into(habitStatus).insert(h.toCompanion());
  }

  Future<bool> updateHabitStatus(HabitStatusModel h) async{
    return await update(habitStatus).replace(h.toCompanion());
  }

  Future<int> deleteHabitStatus(int id) async{
    final query = delete(habitStatus)..where((h) => h.id.equals(id));
    return await query.go();
  }
}
