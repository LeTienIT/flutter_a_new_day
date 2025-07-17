import 'package:drift/drift.dart';

class Habits extends Table{
  IntColumn get id => integer().autoIncrement()(); // id tự tăng
  TextColumn get name => text()();
  TextColumn get repeatDays => text()(); // lưu List<int> dưới dạng JSON
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

}