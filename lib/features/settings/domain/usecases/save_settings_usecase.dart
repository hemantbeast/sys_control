import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/entities/settings_entity.dart';
import 'package:sys_control/features/settings/domain/repositories/settings_repository.dart';

final saveSettingsUseCaseProvider = Provider<SaveSettingsUseCase>((ref) {
  return SaveSettingsUseCase(ref.read(settingsRepositoryProvider));
});

class SaveSettingsUseCase {
  const SaveSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(SettingsEntity settings) {
    return _repository.saveSettings(settings);
  }
}