// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_icon_dao.dart';

// ignore_for_file: type=lint
mixin _$FileIconDaoMixin on DatabaseAccessor<AppDatabase> {
  $FileIconsTable get fileIcons => attachedDatabase.fileIcons;
  FileIconDaoManager get managers => FileIconDaoManager(this);
}

class FileIconDaoManager {
  final _$FileIconDaoMixin _db;
  FileIconDaoManager(this._db);
  $$FileIconsTableTableManager get fileIcons =>
      $$FileIconsTableTableManager(_db.attachedDatabase, _db.fileIcons);
}
