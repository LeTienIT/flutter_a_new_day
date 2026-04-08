import 'package:drift/drift.dart';

class FileIcons extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get path => text()(); // đường dẫn ảnh

  RealColumn get posX => real()(); // vị trí X
  RealColumn get posY => real()(); // vị trí Y

  RealColumn get width => real().withDefault(const Constant(80))();
  RealColumn get height => real().withDefault(const Constant(80))();

  IntColumn get page => integer()(); // trang (1 = first, 2 = last)
}