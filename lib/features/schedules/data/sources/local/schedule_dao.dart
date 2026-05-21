import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/core/database/database_providers.dart';

final scheduleDaoProvider = Provider<ScheduleDao>((ref) {
  return ScheduleDao(ref.read(appDatabaseProvider));
});

class ScheduleDao {
  const ScheduleDao(this._db);

  final AppDatabase _db;

  Stream<List<SchedulesTableData>> watchAll() {
    return (_db.select(_db.schedulesTable)..orderBy([(t) => OrderingTerm.desc(t.id)])).watch();
  }

  Future<int> insert(SchedulesTableCompanion entry) {
    return _db.into(_db.schedulesTable).insert(entry);
  }

  Future<bool> update(SchedulesTableCompanion entry) {
    return _db.update(_db.schedulesTable).replace(entry);
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.schedulesTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> toggleEnabled(int id, {required bool isEnabled}) {
    return (_db.update(_db.schedulesTable)..where((t) => t.id.equals(id))).write(
      SchedulesTableCompanion(isEnabled: Value(isEnabled)),
    );
  }
}
