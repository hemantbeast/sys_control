import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/settings/data/repositories/db_settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/entities/setting_item_entity.dart';
import 'package:sys_control/features/settings/domain/repositories/db_settings_repository.dart';

final watchSettingItemsUseCaseProvider = Provider<WatchSettingItemsUseCase>((ref) {
  return WatchSettingItemsUseCase(ref.watch(dbSettingsRepositoryProvider));
});

class WatchSettingItemsUseCase {
  const WatchSettingItemsUseCase(this._repository);

  final DbSettingsRepository _repository;

  Stream<List<SettingItemEntity>> call(int categoryId) {
    return _repository.watchItems(categoryId);
  }
}
