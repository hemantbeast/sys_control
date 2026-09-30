import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sys_control/core/database/db_path_resolver.dart';
import 'package:sys_control/core/utils/sql_script_parser.dart';
import 'package:sys_control/features/dashboard/databases/device_state_table.dart';
import 'package:sys_control/features/schedules/databases/schedules_table.dart';
import 'package:sys_control/features/settings/databases/setting_categories_table.dart';
import 'package:sys_control/features/settings/databases/setting_definitions_table.dart';
import 'package:sys_control/features/settings/databases/setting_values_table.dart';
import 'package:sys_control/features/settings/databases/settings_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SchedulesTable,
    SettingsTable,
    SettingCategoriesTable,
    SettingDefinitionsTable,
    SettingValuesTable,
    DeviceStateTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor, Future<String> Function()? seedLoader})
      : _seedLoader = seedLoader,
        super(executor ?? _openConnection());

  final Future<String> Function()? _seedLoader;

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedSettingTables();
        },
        onUpgrade: (m, from, to) async {
          if (from < 3) {
            await _adoptExternalSchema(m);
          } else if (from < 4) {
            await _reseedSettingDefinitions();
          }
          if (from < 5) {
            await _migrateSchedulesNaming(m);
          }
          if (from < 6) {
            await _createDeviceState(m);
          }
        },
      );

  /// Adopts a database created outside drift (e.g. by the Qt scheduler, which
  /// leaves `user_version = 0`, or `2` once its SettingsRepository migration
  /// has run): create only the tables that are missing and seed the settings
  /// catalog only when it is empty.
  Future<void> _adoptExternalSchema(Migrator m) async {
    final rows = await customSelect("SELECT name FROM sqlite_master WHERE type = 'table'").get();
    final existing = rows.map((row) => row.read<String>('name')).toSet();

    if (!existing.contains('settings_table')) await m.createTable(settingsTable);
    if (!existing.contains('setting_categories')) await m.createTable(settingCategoriesTable);
    if (!existing.contains('settings')) await m.createTable(settingDefinitionsTable);
    if (!existing.contains('setting_values')) await m.createTable(settingValuesTable);

    var alreadySeeded = false;
    if (existing.contains('setting_categories')) {
      final count = await customSelect('SELECT COUNT(*) AS c FROM setting_categories').getSingle();
      alreadySeeded = count.read<int>('c') > 0;
    }
    if (!alreadySeeded) {
      await _seedSettingTables();
    }
  }

  /// Unifies the schedules table on the Qt scheduler's schema (`schedules`
  /// with camelCase columns): drift versions <= 4 used `schedules_table`
  /// with snake_case columns.
  Future<void> _migrateSchedulesNaming(Migrator m) async {
    final rows = await customSelect("SELECT name FROM sqlite_master WHERE type = 'table'").get();
    final existing = rows.map((row) => row.read<String>('name')).toSet();

    final hasLegacy = existing.contains('schedules_table');
    if (!existing.contains('schedules')) {
      await m.createTable(schedulesTable);
    }
    if (!hasLegacy) {
      return;
    }

    await customStatement(
      'INSERT OR IGNORE INTO schedules (id, name, mode, startTime, timer, isEnabled, repeatType, repeatDays) '
      'SELECT id, name, mode, start_time, timer, is_enabled, repeat_type, repeat_days FROM schedules_table',
    );
    await customStatement('DROP TABLE schedules_table');
  }

  /// Creates the shared `device_state` table unless another app (Qt
  /// scheduler) already created it.
  Future<void> _createDeviceState(Migrator m) async {
    final rows = await customSelect("SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'device_state'").get();
    if (rows.isEmpty) {
      await m.createTable(deviceStateTable);
    }
  }

  Future<void> _reseedSettingDefinitions() async {
    await customStatement('DELETE FROM settings');
    await customStatement('DELETE FROM setting_categories');
    await customStatement("DELETE FROM sqlite_sequence WHERE name = 'setting_categories'");
    await _seedSettingTables();
  }

  Future<void> _seedSettingTables() async {
    final loader = _seedLoader ?? _loadSeedAsset;
    for (final statement in parseSqlScript(await loader())) {
      await customStatement(statement);
    }
  }
}

Future<String> _loadSeedAsset() {
  return rootBundle.loadString('assets/database/seed.sql');
}

Future<String> databaseFilePath() {
  return resolveDatabasePath();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File(await databaseFilePath());
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON');
        rawDb.execute('PRAGMA busy_timeout = 3000');
      },
    );
  });
}
