import 'package:drift/drift.dart';

class SchedulesTable extends Table {
  @override
  String get tableName => 'schedules';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get mode => text().nullable()();
  TextColumn get startTime => text().named('startTime').nullable()();
  IntColumn get timer => integer().nullable()();
  BoolColumn get isEnabled => boolean().named('isEnabled').withDefault(const Constant(false)).nullable()();
  IntColumn get repeatType => integer().named('repeatType').withDefault(const Constant(0)).nullable()();
  TextColumn get repeatDays => text().named('repeatDays').nullable()();
}
