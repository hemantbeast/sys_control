import 'package:drift/drift.dart';

@DataClassName('DeviceStateRow')
class DeviceStateTable extends Table {
  @override
  String get tableName => 'device_state';

  TextColumn get unitId => text().named('unitId')();
  TextColumn get unitType => text().named('unitType')();
  RealColumn get temperature => real().nullable()();
  RealColumn get humidity => real().nullable()();
  RealColumn get targetTemp => real().named('targetTemp').nullable()();
  TextColumn get mode => text().nullable()();
  TextColumn get fanSpeed => text().named('fanSpeed').nullable()();
  BoolColumn get isOn => boolean().named('isOn').withDefault(const Constant(true)).nullable()();
  TextColumn get updatedAt => text().named('updatedAt')();

  @override
  Set<Column> get primaryKey => {unitId};
}
