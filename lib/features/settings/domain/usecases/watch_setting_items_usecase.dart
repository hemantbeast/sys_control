import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/settings/data/repositories/db_settings_repository_impl.dart';
import 'package:sys_control/features/settings/domain/entities/setting_item_entity.dart';
import 'package:sys_control/features/settings/domain/repositories/db_settings_repository.dart';

final watchSettingItemsUseCaseProvider = Provider<WatchSettingItemsUseCase>((ref) {
  return WatchSettingItemsUseCase(ref.watch(dbSettingsRepositoryProvider));
});

class WatchSettingItemsUseCase {
  const WatchSettingItemsUseCase(this._repository);

  final DbSettingsRepository _repository;

  Stream<Either<Failure, List<SettingItemEntity>>> call(int categoryId) async* {
    try {
      await for (final items in _repository.watchItems(categoryId)) {
        yield right(items);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
