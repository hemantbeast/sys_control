import 'package:sys_control/features/settings/domain/entities/setting_category_entity.dart';
import 'package:sys_control/features/settings/domain/entities/setting_item_entity.dart';

abstract class DbSettingsRepository {
  Stream<List<SettingCategoryEntity>> watchCategories();
  Stream<List<SettingItemEntity>> watchItems(int categoryId);
  Future<String?> getValue(String key);
  Future<bool> saveValue(String key, String value);
  Future<void> resetToDefaults({int? categoryId});
}
