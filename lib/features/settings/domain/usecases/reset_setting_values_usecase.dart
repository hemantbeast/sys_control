import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/settings/data/repositories/db_settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/repositories/db_settings_repository.dart';

final resetSettingValuesUseCaseProvider = Provider<ResetSettingValuesUseCase>((ref) {
  return ResetSettingValuesUseCase(ref.watch(dbSettingsRepositoryProvider));
});

class ResetSettingValuesUseCase {
  const ResetSettingValuesUseCase(this._repository);

  final DbSettingsRepository _repository;

  Future<Either<Failure, Unit>> call({int? categoryId}) async {
    try {
      await _repository.resetToDefaults(categoryId: categoryId);
      return right(unit);
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
