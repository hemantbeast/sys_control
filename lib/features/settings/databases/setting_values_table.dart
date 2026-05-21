import 'package:drift/drift.dart';
import 'package:sys_control/features/settings/databases/setting_definitions_table.dart';

@DataClassName('SettingValue')
class SettingValuesTable extends Table {
  @override
  String get tableName => 'setting_values';

  TextColumn get settingKey => text().references(SettingDefinitionsTable, #key)();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}
