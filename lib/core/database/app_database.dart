import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sys_control/core/utils/sql_script_parser.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor, Future<String> Function()? seedLoader})
      : _seedLoader = seedLoader,
        super(executor ?? _openConnection());

  final Future<String> Function()? _seedLoader;

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedSettingTables();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(settingsTable);
          }
          if (from < 3) {
            await m.createTable(settingCategoriesTable);
            await m.createTable(settingDefinitionsTable);
            await m.createTable(settingValuesTable);
            await _seedSettingTables();
          }
          if (from < 4) {
            await _reseedSettingDefinitions();
          }
        },
      );

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

Future<String> databaseFilePath() async {
  final dir = await getApplicationSupportDirectory();
  return p.join(dir.path, 'sys_control.sqlite');
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File(await databaseFilePath());
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON'),
    );
  });
}
