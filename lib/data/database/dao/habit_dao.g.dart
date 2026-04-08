// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_dao.dart';

// ignore_for_file: type=lint
mixin _$HabitDAOMixin on DatabaseAccessor<AppDatabase> {
  $HabitsTable get habits => attachedDatabase.habits;
  $HabitStatusTable get habitStatus => attachedDatabase.habitStatus;
  HabitDAOManager get managers => HabitDAOManager(this);
}

class HabitDAOManager {
  final _$HabitDAOMixin _db;
  HabitDAOManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db.attachedDatabase, _db.habits);
  $$HabitStatusTableTableManager get habitStatus =>
      $$HabitStatusTableTableManager(_db.attachedDatabase, _db.habitStatus);
}
