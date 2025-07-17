import 'package:drift/drift.dart';

class Moods extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get emoji => text()(); // lưu emoji
  TextColumn get note => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {date}
  ];
}
