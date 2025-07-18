import 'package:a_new_day/data/database/app_database.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:drift/drift.dart';

extension MoodMapper on Mood{
  MoodModel toModel() => MoodModel(
      id: id,
      date: date,
      emoji: emoji,
      note: note
  );
}
extension MoodModelMapper on MoodModel{
  MoodsCompanion toCompanion({bool nullToAbsent = false}) {
    return MoodsCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      date: Value(date),
      emoji: Value(emoji),
      note: note == null ? const Value.absent() : Value(note!),
    );
  }
}