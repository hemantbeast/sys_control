import 'package:drift/drift.dart';
import 'package:sys_control/features/settings/databases/setting_categories_table.dart';

@DataClassName('SettingDefinition')
class SettingDefinitionsTable extends Table {
  @override
  String get tableName => 'settings';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(SettingCategoriesTable, #id)();
  TextColumn get key => text().unique()();
  TextColumn get label => text()();
  TextColumn get type => text().withDefault(const Constant('input'))();
  TextColumn get dataType => text().withDefault(const Constant('string'))();
  TextColumn get defaultValue => text().nullable()();
  TextColumn get screenType => text().withDefault(const Constant('editor'))();
  TextColumn get customScreen => text().nullable()();
  RealColumn get minValue => real().nullable()();
  RealColumn get maxValue => real().nullable()();
  RealColumn get stepValue => real().withDefault(const Constant(1))();
  TextColumn get unit => text().withDefault(const Constant(''))();
  TextColumn get options => text().withDefault(const Constant(''))();
  IntColumn get maxLength => integer().withDefault(const Constant(256))();
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get isReadonly => boolean().withDefault(const Constant(false))();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
