import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/setting_table.dart';

part 'setting_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingDao extends DatabaseAccessor<AppDatabase>
    with _$SettingDaoMixin {
  SettingDao(super.db);

  // Get value by key
  Future<String?> getValue(String key) async {
    final query = select(settings)..where((tbl) => tbl.key.equals(key));
    final result = await query.getSingleOrNull();
    return result?.value;
  }

  // Watch value (reactive)
  Stream<String?> watchValue(String key) {
    final query = select(settings)..where((tbl) => tbl.key.equals(key));
    return query.watchSingleOrNull().map((row) => row?.value);
  }

  // Set value (upsert)
  Future<void> setValue(String key, String value) async {
    await into(settings).insertOnConflictUpdate(
      SettingsCompanion(
        key: Value(key),
        value: Value(value),
      ),
    );
  }

  Future<String?> getOrCreate(String key, {String defaultValue = 'false'}) async {
    final existing = await getValue(key);

    if (existing != null) return existing;

    await setValue(key, defaultValue);
    return defaultValue;
  }

  // Remove
  Future<void> deleteKey(String key) async {
    await (delete(settings)..where((tbl) => tbl.key.equals(key))).go();
  }
}