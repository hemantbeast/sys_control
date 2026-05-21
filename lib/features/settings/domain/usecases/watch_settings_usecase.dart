import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/entities/settings_entity.dart';
import 'package:sys_control/features/settings/domain/repositories/settings_repository.dart';

final watchSettingsUseCaseProvider = Provider<WatchSettingsUseCase>((ref) {
  return WatchSettingsUseCase(ref.read(settingsRepositoryProvider));
});

class WatchSettingsUseCase {
  const WatchSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Stream<SettingsEntity> call() {
    return _repository.watchSettings();
  }
}