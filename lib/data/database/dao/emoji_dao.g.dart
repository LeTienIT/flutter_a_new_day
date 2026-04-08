// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_dao.dart';

// ignore_for_file: type=lint
mixin _$EmojiDAOMixin on DatabaseAccessor<AppDatabase> {
  $EmojiTableTable get emojiTable => attachedDatabase.emojiTable;
  EmojiDAOManager get managers => EmojiDAOManager(this);
}

class EmojiDAOManager {
  final _$EmojiDAOMixin _db;
  EmojiDAOManager(this._db);
  $$EmojiTableTableTableManager get emojiTable =>
      $$EmojiTableTableTableManager(_db.attachedDatabase, _db.emojiTable);
}
