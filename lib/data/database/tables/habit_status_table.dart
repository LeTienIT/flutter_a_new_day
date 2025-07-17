import 'package:drift/drift.dart';

class HabitStatus extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer()();
  TextColumn get habitTitle => text()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, date}
  ];
}
