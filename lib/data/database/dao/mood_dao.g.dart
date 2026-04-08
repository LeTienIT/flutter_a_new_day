// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_dao.dart';

// ignore_for_file: type=lint
mixin _$MoodDAOMixin on DatabaseAccessor<AppDatabase> {
  $MoodsTable get moods => attachedDatabase.moods;
  MoodDAOManager get managers => MoodDAOManager(this);
}

class MoodDAOManager {
  final _$MoodDAOMixin _db;
  MoodDAOManager(this._db);
  $$MoodsTableTableManager get moods =>
      $$MoodsTableTableManager(_db.attachedDatabase, _db.moods);
}
