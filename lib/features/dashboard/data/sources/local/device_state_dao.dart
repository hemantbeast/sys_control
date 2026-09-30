import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/core/database/database_providers.dart';

final deviceStateDaoProvider = Provider<DeviceStateDao>((ref) {
  return DeviceStateDao(ref.read(appDatabaseProvider));
});

class DeviceStateDao {
  const DeviceStateDao(this._db);

  final AppDatabase _db;

  Stream<List<DeviceStateRow>> watchAll() {
    return (_db.select(_db.deviceStateTable)..orderBy([(t) => OrderingTerm.asc(t.unitId)])).watch();
  }

  Future<void> upsert(DeviceStateTableCompanion entry) {
    return _db.into(_db.deviceStateTable).insertOnConflictUpdate(entry);
  }

  Future<int> writeFields(String unitId, DeviceStateTableCompanion entry) {
    return (_db.update(_db.deviceStateTable)..where((t) => t.unitId.equals(unitId))).write(entry);
  }
}
