import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/settings/domain/entities/setting_category_entity.dart';
import 'package:sys_control/features/settings/domain/usecases/watch_setting_categories_usecase.dart';
import 'package:sys_control/features/settings/ui/states/settings_categories_state.dart';

final settingsCategoriesProvider =
    NotifierProvider.autoDispose<SettingsCategoriesNotifier, SettingsCategoriesState>(
  SettingsCategoriesNotifier.new,
);

class SettingsCategoriesNotifier extends Notifier<SettingsCategoriesState> {
  StreamSubscription<Either<Failure, List<SettingCategoryEntity>>>? _subscription;

  @override
  SettingsCategoriesState build() {
    final useCase = ref.watch(watchSettingCategoriesUseCaseProvider);
    _subscription = useCase().listen(
      (result) {
        result.fold(
          (failure) {
            state = state.copyWith(isLoading: false);
          },
          (categories) {
            state = state.copyWith(categories: categories, isLoading: false);
          },
        );
      },
    );
    ref.onDispose(() => _subscription?.cancel());
    return SettingsCategoriesState.initial();
  }
}
