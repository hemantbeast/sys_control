import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/settings/data/repositories/db_settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/repositories/db_settings_repository.dart';

final getSettingValueUseCaseProvider = Provider<GetSettingValueUseCase>((ref) {
  return GetSettingValueUseCase(ref.watch(dbSettingsRepositoryProvider));
});

class GetSettingValueUseCase {
  const GetSettingValueUseCase(this._repository);

  final DbSettingsRepository _repository;

  Future<String?> call(String key) {
    return _repository.getValue(key);
  }
}
