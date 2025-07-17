import 'package:a_new_day/data/database/app_database.dart';
import 'package:a_new_day/data/models/emoji_model.dart';
import 'package:a_new_day/data/models/mood_model.dart';
import 'package:drift/drift.dart';

extension EmojiMapper on EmojiTableData{
  EmojiModel toModel() => EmojiModel(
      id: id,
      path: path,
      name: name,
      enable: enable
  );
}
extension EmojiModelMapper on EmojiModel{
  EmojiTableCompanion toCompanion({bool nullToAbsent = false}) {
    return EmojiTableCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      path: Value(path),
      name: Value(name),
      enable: Value(enable),
    );
  }
}