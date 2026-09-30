import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/settings/data/repositories/db_settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/repositories/db_settings_repository.dart';

final watchSettingValueUseCaseProvider = Provider<WatchSettingValueUseCase>((ref) {
  return WatchSettingValueUseCase(ref.watch(dbSettingsRepositoryProvider));
});

class WatchSettingValueUseCase {
  const WatchSettingValueUseCase(this._repository);

  final DbSettingsRepository _repository;

  Stream<String?> call(String key) {
    return _repository.watchValue(key);
  }
}
