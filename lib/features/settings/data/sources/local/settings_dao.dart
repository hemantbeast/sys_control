import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/core/database/database_providers.dart';

final settingsDaoProvider = Provider<SettingsDao>((ref) {
  return SettingsDao(ref.read(appDatabaseProvider));
});

class SettingsDao {
  const SettingsDao(this._db);

  final AppDatabase _db;

  Stream<SettingsTableData> watch() {
    return (_db.select(_db.settingsTable)..limit(1)).watch().map(
          (rows) => rows.isEmpty ? _defaults() : rows.first,
        );
  }

  Future<SettingsTableData> get() async {
    final row = await (_db.select(_db.settingsTable)..limit(1)).getSingleOrNull();
    return row ?? _defaults();
  }

  Future<void> upsert(SettingsTableCompanion entry) async {
    final existing = await (_db.select(_db.settingsTable)..limit(1)).getSingleOrNull();
    if (existing != null) {
      await _db.update(_db.settingsTable).replace(entry);
    } else {
      await _db.into(_db.settingsTable).insert(entry);
    }
  }

  SettingsTableData _defaults() {
    return const SettingsTableData(
      id: 1,
      temperatureUnit: 0,
      language: 'en',
      minTemp: 15,
      maxTemp: 35,
      defaultMode: 0,
      defaultFanSpeed: 0,
      defaultTargetTemp: 25,
      energyRate: 0.15,
      currencySymbol: r'$',
      themeMode: 0,
    );
  }
}