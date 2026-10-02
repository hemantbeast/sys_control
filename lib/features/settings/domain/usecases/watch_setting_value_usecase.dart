import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/settings/data/repositories/db_settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/repositories/db_settings_repository.dart';

final watchSettingValueUseCaseProvider = Provider<WatchSettingValueUseCase>((ref) {
  return WatchSettingValueUseCase(ref.watch(dbSettingsRepositoryProvider));
});

class WatchSettingValueUseCase {
  const WatchSettingValueUseCase(this._repository);

  final DbSettingsRepository _repository;

  Stream<Either<Failure, String?>> call(String key) async* {
    try {
      await for (final value in _repository.watchValue(key)) {
        yield right(value);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
