import 'package:drift/drift.dart';

class SchedulesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get mode => text().nullable()();
  TextColumn get startTime => text().nullable()();
  IntColumn get timer => integer().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(false)).nullable()();
  IntColumn get repeatType => integer().withDefault(const Constant(0)).nullable()();
  TextColumn get repeatDays => text().nullable()();
}
