import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/core/database/database_providers.dart';

final settingsDbDaoProvider = Provider<SettingsDbDao>((ref) {
  return SettingsDbDao(ref.watch(appDatabaseProvider));
});

class SettingsDbDao {
  const SettingsDbDao(this._db);

  final AppDatabase _db;

  Stream<List<SettingCategory>> watchCategories() {
    return (_db.select(_db.settingCategoriesTable)
          ..where((t) => t.parentId.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Stream<List<QueryRow>> watchItems(int categoryId) {
    return _db
        .customSelect(
          '''
          SELECT s.id, s.category_id, s.key, s.label, s.type, s.data_type,
                 s.screen_type, s.custom_screen, s.min_value, s.max_value,
                 s.step_value, s.unit, s.options, s.max_length, s.description,
                 s.is_readonly, s.is_visible, s.sort_order, s.default_value,
                 COALESCE(sv.value, s.default_value) AS current_value
          FROM settings s
          LEFT JOIN setting_values sv ON sv.setting_key = s.key
          WHERE s.category_id = ? AND s.is_visible = 1
          ORDER BY s.sort_order
          ''',
          variables: [Variable<int>(categoryId)],
          readsFrom: {_db.settingDefinitionsTable, _db.settingValuesTable},
        )
        .watch();
  }

  Future<SettingDefinition?> getDefinition(String key) {
    return (_db.select(_db.settingDefinitionsTable)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
  }

  Future<String?> getValue(String key) async {
    final row = await _db
        .customSelect(
          '''
          SELECT COALESCE(sv.value, s.default_value) AS val
          FROM settings s
          LEFT JOIN setting_values sv ON sv.setting_key = s.key
          WHERE s.key = ?
          ''',
          variables: [Variable<String>(key)],
          readsFrom: {_db.settingDefinitionsTable, _db.settingValuesTable},
        )
        .getSingleOrNull();
    return row?.readNullable<String>('val');
  }

  Stream<String?> watchValue(String key) {
    return _db
        .customSelect(
          '''
          SELECT COALESCE(sv.value, s.default_value) AS val
          FROM settings s
          LEFT JOIN setting_values sv ON sv.setting_key = s.key
          WHERE s.key = ?
          ''',
          variables: [Variable<String>(key)],
          readsFrom: {_db.settingDefinitionsTable, _db.settingValuesTable},
        )
        .watchSingleOrNull()
        .map((row) => row?.readNullable<String>('val'));
  }

  Future<void> setValue(String key, String value) {
    return _db
        .into(_db.settingValuesTable)
        .insertOnConflictUpdate(
          SettingValuesTableCompanion.insert(settingKey: key, value: value),
        );
  }

  Future<void> clearValues({int? categoryId}) async {
    if (categoryId == null) {
      await _db.delete(_db.settingValuesTable).go();
      return;
    }

    final rows = await (_db.select(_db.settingDefinitionsTable)
          ..where((t) => t.categoryId.equals(categoryId)))
        .get();
    final keys = rows.map((row) => row.key).toList();
    if (keys.isEmpty) {
      return;
    }

    await (_db.delete(_db.settingValuesTable)..where((t) => t.settingKey.isIn(keys))).go();
  }
}
