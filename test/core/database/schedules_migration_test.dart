import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as raw_sqlite;
import 'package:sys_control/core/database/app_database.dart';

const _qtSchedulesDdl = '''
CREATE TABLE schedules (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  mode TEXT,
  startTime TEXT,
  timer INTEGER,
  isEnabled INTEGER CHECK (isEnabled IN (0, 1)),
  repeatType INTEGER,
  repeatDays TEXT
)
''';

const _qtCategoriesDdl = '''
CREATE TABLE setting_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  key TEXT NOT NULL UNIQUE,
  label TEXT NOT NULL,
  icon TEXT DEFAULT '',
  sort_order INTEGER DEFAULT 0,
  parent_id INTEGER DEFAULT NULL,
  FOREIGN KEY (parent_id) REFERENCES setting_categories(id)
)
''';

const _qtSettingsDdl = '''
CREATE TABLE settings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category_id INTEGER NOT NULL,
  key TEXT NOT NULL UNIQUE,
  label TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'input',
  data_type TEXT NOT NULL DEFAULT 'string',
  default_value TEXT,
  screen_type TEXT NOT NULL DEFAULT 'editor',
  custom_screen TEXT,
  min_value REAL,
  max_value REAL,
  step_value REAL DEFAULT 1,
  unit TEXT DEFAULT '',
  options TEXT DEFAULT '',
  max_length INTEGER DEFAULT 256,
  description TEXT DEFAULT '',
  is_readonly INTEGER DEFAULT 0,
  is_visible INTEGER DEFAULT 1,
  sort_order INTEGER DEFAULT 0,
  FOREIGN KEY (category_id) REFERENCES setting_categories(id)
)
''';

const _qtValuesDdl = '''
CREATE TABLE setting_values (
  setting_key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  FOREIGN KEY (setting_key) REFERENCES settings(key)
)
''';

const _legacySchedulesDdl = '''
CREATE TABLE schedules_table (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  mode TEXT NULL,
  start_time TEXT NULL,
  timer INTEGER NULL,
  is_enabled INTEGER NULL DEFAULT 0 CHECK (is_enabled IN (0, 1)),
  repeat_type INTEGER NULL DEFAULT 0,
  repeat_days TEXT NULL
)
''';

Future<AppDatabase> _openOver(
  File file,
  List<String> setupStatements, {
  int? userVersion,
  String seedScript = '',
}) async {
  final raw = raw_sqlite.sqlite3.open(file.path);
  for (final statement in setupStatements) {
    raw.execute(statement);
  }
  if (userVersion != null) {
    raw.execute('PRAGMA user_version = $userVersion');
  }
  raw.dispose();
  return AppDatabase(executor: NativeDatabase(file), seedLoader: () async => seedScript);
}

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('schedules_migration');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('adopts a Qt scheduler database and reads its schedules', () async {
    final file = File('${tempDir.path}/deluxe.db');
    final db = await _openOver(file, [
      _qtSchedulesDdl,
      _qtCategoriesDdl,
      _qtSettingsDdl,
      _qtValuesDdl,
      "INSERT INTO schedules (name, mode, startTime, timer, isEnabled, repeatType, repeatDays) "
          "VALUES ('Morning', 'heat', '07:00', 30, 1, 2, '1,2,3')",
      "INSERT INTO setting_categories (key, label, icon, sort_order) VALUES ('general', 'General', 'settings', 0)",
    ]);
    addTearDown(db.close);

    final schedules = await db.select(db.schedulesTable).get();
    expect(schedules, hasLength(1));
    expect(schedules.single.name, 'Morning');
    expect(schedules.single.startTime, '07:00');
    expect(schedules.single.isEnabled, true);
    expect(schedules.single.repeatType, 2);
    expect(schedules.single.repeatDays, '1,2,3');

    final categories = await db.select(db.settingCategoriesTable).get();
    expect(categories, hasLength(1));

    final tables = await db.customSelect("SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'device_state'").get();
    expect(tables, hasLength(1));

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 6);
  });

  test('adopts a Qt database already at user_version 2 without reseeding', () async {
    final file = File('${tempDir.path}/deluxe_v2.db');
    final db = await _openOver(
      file,
      [
        _qtSchedulesDdl,
        _qtCategoriesDdl,
        _qtSettingsDdl,
        _qtValuesDdl,
        "INSERT INTO setting_categories (key, label, icon, sort_order) VALUES ('general', 'General', 'settings', 0)",
        "INSERT INTO settings (category_id, key, label) VALUES (1, 'theme', 'Theme')",
        "INSERT INTO setting_values (setting_key, value) VALUES ('theme', 'dark')",
      ],
      userVersion: 2,
      seedScript: "INSERT INTO setting_categories (key, label, icon, sort_order) VALUES ('general', 'General', 'settings', 0)",
    );
    addTearDown(db.close);

    final categories = await db.select(db.settingCategoriesTable).get();
    expect(categories, hasLength(1));

    final values = await db.select(db.settingValuesTable).get();
    expect(values, hasLength(1));

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 6);
  });

  test('migrates drift v4 snake_case schedules_table into Qt-shaped schedules', () async {
    final file = File('${tempDir.path}/legacy.db');
    final db = await _openOver(
      file,
      [
        _legacySchedulesDdl,
        "INSERT INTO schedules_table (name, mode, start_time, timer, is_enabled, repeat_type, repeat_days) "
            "VALUES ('Night', 'cool', '22:00', 15, 1, 0, NULL)",
      ],
      userVersion: 4,
    );
    addTearDown(db.close);

    final schedules = await db.select(db.schedulesTable).get();
    expect(schedules, hasLength(1));
    expect(schedules.single.name, 'Night');
    expect(schedules.single.startTime, '22:00');
    expect(schedules.single.isEnabled, true);

    final tables = await db.customSelect("SELECT name FROM sqlite_master WHERE type = 'table'").get();
    expect(tables.map((row) => row.read<String>('name')), isNot(contains('schedules_table')));
  });
}
