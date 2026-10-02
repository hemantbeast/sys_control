import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/core/database/external_db_change_detector.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('external_db_change_detector');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  Future<AppDatabase> openDb(File file) async {
    final db = AppDatabase(executor: NativeDatabase(file), seedLoader: () async => '');
    await db.customSelect('SELECT 1').getSingle();
    return db;
  }

  Future<ExternalDbChangeDetector> startDetector(AppDatabase db, String watchedPath, void Function() onFileReplaced) async {
    final detector = ExternalDbChangeDetector(
      db,
      dbPathOverride: watchedPath,
      onFileReplaced: onFileReplaced,
      pollInterval: const Duration(milliseconds: 150),
      debounceDelay: const Duration(milliseconds: 50),
    );
    addTearDown(detector.dispose);
    await detector.start();
    return detector;
  }

  test('a write through our own connection must not be treated as a whole-file replacement', () async {
    final file = File('${tempDir.path}/db.sqlite');
    final db = await openDb(file);
    addTearDown(db.close);

    var replaced = 0;
    await startDetector(db, file.path, () => replaced++);

    await Future<void>.delayed(const Duration(milliseconds: 50));
    await db.customStatement('CREATE TABLE t (id INTEGER PRIMARY KEY)');
    await db.customStatement('INSERT INTO t (id) VALUES (1)');

    await Future<void>.delayed(const Duration(milliseconds: 1000));
    expect(
      replaced,
      0,
      reason: 'own writes bump the file mtime but not PRAGMA data_version; '
          'the detector must not tear the database down for them',
    );
  });

  test('a connection that keeps failing escalates to file replacement', () async {
    final file = File('${tempDir.path}/db.sqlite');
    final db = await openDb(file);

    var replaced = 0;
    await startDetector(db, file.path, () => replaced++);

    await db.close();
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    expect(replaced, greaterThanOrEqualTo(1));
  });

  test(
    'replacing the whole file at the watched path is treated as a file replacement',
    () async {
      final dbFile = File('${tempDir.path}/db.sqlite');
      final marker = File('${tempDir.path}/marker.db')..writeAsStringSync('v1');
      final db = await openDb(dbFile);
      addTearDown(db.close);

      var replaced = 0;
      await startDetector(db, marker.path, () => replaced++);

      marker.deleteSync();
      marker.writeAsStringSync('v2');

      await Future<void>.delayed(const Duration(milliseconds: 600));
      expect(replaced, greaterThanOrEqualTo(1));
    },
    skip: Platform.isWindows ? false : 'creation-time discriminator is Windows-only',
  );
}
