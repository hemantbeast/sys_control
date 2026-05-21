import 'package:drift/drift.dart';

class SettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get temperatureUnit => integer().withDefault(const Constant(0))();
  TextColumn get language => text().withDefault(const Constant('en'))();
  RealColumn get minTemp => real().withDefault(const Constant(15.0))();
  RealColumn get maxTemp => real().withDefault(const Constant(35.0))();
  IntColumn get defaultMode => integer().withDefault(const Constant(0))();
  IntColumn get defaultFanSpeed => integer().withDefault(const Constant(0))();
  RealColumn get defaultTargetTemp => real().withDefault(const Constant(25.0))();
  RealColumn get energyRate => real().withDefault(const Constant(0.15))();
  TextColumn get currencySymbol => text().withDefault(const Constant(r'$'))();
  IntColumn get themeMode => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}