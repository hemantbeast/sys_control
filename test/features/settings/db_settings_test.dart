import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/features/settings/data/repositories/db_settings_repository_impl.dart';
import 'package:sys_control/features/settings/data/sources/local/settings_db_dao.dart';

void main() {
  late AppDatabase db;
  late DbSettingsRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase(
      executor: NativeDatabase.memory(),
      seedLoader: () async => File('assets/database/seed.sql').readAsString(),
    );
    await db.customSelect('SELECT 1').get();
    repository = DbSettingsRepositoryImpl(SettingsDbDao(db));
  });

  tearDown(() async {
    await db.close();
  });

  test('seeds top-level categories ordered by sort order', () async {
    final categories = await repository.watchCategories().first;

    expect(
      categories.map((category) => category.key).toList(),
      <String>['general', 'display', 'audio', 'network'],
    );
  });

  test('items fall back to default values when no override exists', () async {
    final items = await repository.watchItems(2).first;

    final brightness = items.firstWhere((item) => item.key == 'brightness');
    expect(brightness.value, '70');
    expect(brightness.displayValue, '70%');
    expect(brightness.minValue, 0);
    expect(brightness.maxValue, 100);
  });

  test('readonly items are surfaced', () async {
    final items = await repository.watchItems(1).first;

    final firmware = items.firstWhere((item) => item.key == 'firmware_version');
    expect(firmware.isReadOnly, isTrue);
    expect(firmware.value, '1.0.0');
  });

  test('saveValue overrides the default and streams re-emit', () async {
    final updated = repository
        .watchItems(2)
        .firstWhere(
          (items) => items.firstWhere((item) => item.key == 'brightness').value == '80',
        );

    expect(await repository.saveValue('brightness', '80'), isTrue);
    expect((await updated).firstWhere((item) => item.key == 'brightness').value, '80');
    expect(await repository.getValue('brightness'), '80');
  });

  test('saveValue rejects out-of-range numbers', () async {
    expect(await repository.saveValue('brightness', '500'), isFalse);
    expect(await repository.saveValue('brightness', 'abc'), isFalse);
    expect(await repository.getValue('brightness'), '70');
  });

  test('saveValue rejects invalid dropdown options', () async {
    expect(await repository.saveValue('language', 'Klingon'), isFalse);
    expect(await repository.saveValue('language', 'Français'), isTrue);
  });

  test('saveValue rejects overlong input', () async {
    expect(await repository.saveValue('hostname', 'a' * 300), isFalse);
    expect(await repository.saveValue('hostname', 'device-1'), isTrue);
  });

  test('saveValue accepts unvalidated types like toggles', () async {
    expect(await repository.saveValue('auto_update', '0'), isTrue);

    final items = await repository.watchItems(1).first;
    expect(items.firstWhere((item) => item.key == 'auto_update').boolValue, isFalse);
  });

  test('unknown keys are rejected', () async {
    expect(await repository.saveValue('missing_key', '1'), isFalse);
  });

  test('resetToDefaults clears overrides for one category only', () async {
    await repository.saveValue('brightness', '90');
    await repository.saveValue('language', 'Français');

    await repository.resetToDefaults(categoryId: 2);

    expect(await repository.getValue('brightness'), '70');
    expect(await repository.getValue('language'), 'Français');
  });

  test('resetToDefaults without a category clears everything', () async {
    await repository.saveValue('brightness', '90');
    await repository.saveValue('language', 'Français');

    await repository.resetToDefaults();

    expect(await repository.getValue('brightness'), '70');
    expect(await repository.getValue('language'), 'English');
  });
}
