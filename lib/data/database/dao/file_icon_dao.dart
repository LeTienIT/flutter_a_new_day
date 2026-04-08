import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/file_icon_table.dart';

part 'file_icon_dao.g.dart';

@DriftAccessor(tables: [FileIcons])
class FileIconDao extends DatabaseAccessor<AppDatabase>
    with _$FileIconDaoMixin {
  FileIconDao(super.db);

  /// ================= CREATE =================
  Future<int> insertIcon({
    required String path,
    required double x,
    required double y,
    required int page,
    double width = 80.0 / 350,
    double height = 80.0 / 550,
  }) {
    return into(fileIcons).insert(
      FileIconsCompanion(
        path: Value(path),
        posX: Value(x),
        posY: Value(y),
        page: Value(page),
        width: Value(width),
        height: Value(height),
      ),
    );
  }

  /// ================= READ =================
  Future<List<FileIcon>> getAll() {
    return select(fileIcons).get();
  }

  Stream<List<FileIcon>> watchAll() {
    return select(fileIcons).watch();
  }

  Future<List<FileIcon>> getByPage([int? page]) {
    final query = select(fileIcons);

    if (page != null) {
      query.where((tbl) => tbl.page.equals(page));
    }

    return query.get();
  }

  Stream<List<FileIcon>> watchByPage(int page) {
    return (select(fileIcons)
      ..where((tbl) => tbl.page.equals(page)))
        .watch();
  }

  /// ================= UPDATE =================
  Future<void> updatePosition(int id, double x, double y) {
    return (update(fileIcons)..where((tbl) => tbl.id.equals(id))).write(
      FileIconsCompanion(
        posX: Value(x),
        posY: Value(y),
      ),
    );
  }

  Future<void> updateIcon(FileIcon icon) {
    return update(fileIcons).replace(icon);
  }

  /// ================= DELETE =================
  Future<void> deleteById(int id) {
    return (delete(fileIcons)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteAll() {
    return delete(fileIcons).go();
  }

  Future<void> updateSize(int id, double w, double h) {
    return (update(fileIcons)..where((tbl) => tbl.id.equals(id))).write(
      FileIconsCompanion(
        width: Value(w),
        height: Value(h),
      ),
    );
  }
}