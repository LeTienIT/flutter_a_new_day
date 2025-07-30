import 'package:drift/drift.dart';

class EmojiTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get path => text()();
  TextColumn get name => text()();
  BoolColumn get enable => boolean().withDefault(const Constant(false))();
  IntColumn get nangLuong => integer().withDefault(const Constant(0))();
}