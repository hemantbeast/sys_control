import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/settings/domain/entities/setting_category_entity.dart';
import 'package:sys_control/features/settings/domain/usecases/watch_setting_categories_usecase.dart';
import 'package:sys_control/features/settings/ui/states/settings_categories_state.dart';

final settingsCategoriesProvider =
    NotifierProvider.autoDispose<SettingsCategoriesNotifier, SettingsCategoriesState>(
  SettingsCategoriesNotifier.new,
);

class SettingsCategoriesNotifier extends Notifier<SettingsCategoriesState> {
  StreamSubscription<List<SettingCategoryEntity>>? _subscription;

  @override
  SettingsCategoriesState build() {
    final useCase = ref.watch(watchSettingCategoriesUseCaseProvider);
    _subscription = useCase().listen(
      (categories) => state = state.copyWith(categories: categories, isLoading: false),
      onError: (Object _) => state = state.copyWith(isLoading: false),
    );
    ref.onDispose(() => _subscription?.cancel());
    return SettingsCategoriesState.initial();
  }
}
