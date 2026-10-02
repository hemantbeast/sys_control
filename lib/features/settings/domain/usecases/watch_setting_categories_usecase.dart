import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/settings/data/repositories/db_settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/entities/setting_category_entity.dart';
import 'package:sys_control/features/settings/domain/repositories/db_settings_repository.dart';

final watchSettingCategoriesUseCaseProvider = Provider<WatchSettingCategoriesUseCase>((ref) {
  return WatchSettingCategoriesUseCase(ref.watch(dbSettingsRepositoryProvider));
});

class WatchSettingCategoriesUseCase {
  const WatchSettingCategoriesUseCase(this._repository);

  final DbSettingsRepository _repository;

  Stream<Either<Failure, List<SettingCategoryEntity>>> call() async* {
    try {
      await for (final categories in _repository.watchCategories()) {
        yield right(categories);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
