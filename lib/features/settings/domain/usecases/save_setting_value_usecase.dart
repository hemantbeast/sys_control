import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/settings/data/repositories/db_settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/repositories/db_settings_repository.dart';

final saveSettingValueUseCaseProvider = Provider<SaveSettingValueUseCase>((ref) {
  return SaveSettingValueUseCase(ref.watch(dbSettingsRepositoryProvider));
});

class SaveSettingValueUseCase {
  const SaveSettingValueUseCase(this._repository);

  final DbSettingsRepository _repository;

  Future<bool> call(String key, String value) {
    return _repository.saveValue(key, value);
  }
}
