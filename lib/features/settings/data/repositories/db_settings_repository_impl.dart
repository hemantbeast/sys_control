import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/features/settings/data/sources/local/settings_db_dao.dart';
import 'package:sys_control/features/settings/domain/entities/setting_category_entity.dart';
import 'package:sys_control/features/settings/domain/entities/setting_item_entity.dart';
import 'package:sys_control/features/settings/domain/repositories/db_settings_repository.dart';

final dbSettingsRepositoryProvider = Provider<DbSettingsRepository>((ref) {
  return DbSettingsRepositoryImpl(ref.watch(settingsDbDaoProvider));
});

class DbSettingsRepositoryImpl implements DbSettingsRepository {
  const DbSettingsRepositoryImpl(this._dao);

  final SettingsDbDao _dao;

  @override
  Stream<List<SettingCategoryEntity>> watchCategories() {
    return _dao.watchCategories().map((rows) => rows.map(_toCategoryEntity).toList());
  }

  @override
  Stream<List<SettingItemEntity>> watchItems(int categoryId) {
    return _dao.watchItems(categoryId).map((rows) {
      final items = <SettingItemEntity>[];

      for (final row in rows) {
        final item = _toItemEntity(row);

        if (item.key.isEmpty || item.type.isEmpty) {
          continue;
        }
        if (item.type == 'range' && (item.minValue ?? 0) == 0 && (item.maxValue ?? 0) == 0) {
          continue;
        }

        items.add(item);
      }
      return items;
    });
  }

  @override
  Future<String?> getValue(String key) {
    return _dao.getValue(key);
  }

  @override
  Stream<String?> watchValue(String key) {
    return _dao.watchValue(key);
  }

  @override
  Future<bool> saveValue(String key, String value) async {
    if (!await _validate(key, value)) {
      return false;
    }
    await _dao.setValue(key, value);
    return true;
  }

  @override
  Future<void> resetToDefaults({int? categoryId}) {
    return _dao.clearValues(categoryId: categoryId);
  }

  Future<bool> _validate(String key, String value) async {
    final definition = await _dao.getDefinition(key);
    if (definition == null) {
      return false;
    }

    switch (definition.type) {
      case 'range':
        final number = double.tryParse(value);
        if (number == null) {
          return false;
        }
        return number >= (definition.minValue ?? 0) && number <= (definition.maxValue ?? 0);
      case 'dropdown':
        return _parseOptions(definition.options).contains(value);
      case 'input':
        return value.length <= definition.maxLength;
      default:
        return true;
    }
  }

  List<String> _parseOptions(String json) {
    if (json.isEmpty) {
      return const <String>[];
    }
    try {
      final decoded = jsonDecode(json) as List<dynamic>;
      return decoded.whereType<String>().toList();
    } on FormatException {
      return const <String>[];
    }
  }

  SettingCategoryEntity _toCategoryEntity(SettingCategory row) {
    return SettingCategoryEntity(
      id: row.id,
      key: row.key,
      label: row.label,
      icon: row.icon,
      sortOrder: row.sortOrder,
      parentId: row.parentId ?? -1,
    );
  }

  SettingItemEntity _toItemEntity(QueryRow row) {
    return SettingItemEntity(
      id: row.read<int>('id'),
      categoryId: row.read<int>('category_id'),
      key: row.read<String>('key'),
      label: row.read<String>('label'),
      type: row.read<String>('type'),
      dataType: row.read<String>('data_type'),
      screenType: row.read<String>('screen_type'),
      customScreen: row.readNullable<String>('custom_screen'),
      unit: row.read<String>('unit'),
      description: row.read<String>('description'),
      maxLength: row.read<int>('max_length'),
      sortOrder: row.read<int>('sort_order'),
      isReadOnly: row.read<int>('is_readonly') == 1,
      isVisible: row.read<int>('is_visible') == 1,
      minValue: row.readNullable<double>('min_value'),
      maxValue: row.readNullable<double>('max_value'),
      stepValue: row.read<double>('step_value'),
      options: _parseOptions(row.read<String>('options')),
      value: row.readNullable<String>('current_value'),
      defaultValue: row.readNullable<String>('default_value'),
    );
  }
}
