import 'package:drift/drift.dart';

@DataClassName('SettingCategory')
class SettingCategoriesTable extends Table {
  @override
  String get tableName => 'setting_categories';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get label => text()();
  TextColumn get icon => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get parentId => integer().nullable().references(SettingCategoriesTable, #id)();
}
