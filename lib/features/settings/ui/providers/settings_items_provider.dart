import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/app/themes/theme_manager.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/settings/domain/entities/setting_item_entity.dart';
import 'package:sys_control/features/settings/domain/enums/language_enum.dart';
import 'package:sys_control/features/settings/domain/enums/temperature_unit_enum.dart';
import 'package:sys_control/features/settings/domain/usecases/reset_setting_values_usecase.dart';
import 'package:sys_control/features/settings/domain/usecases/save_setting_value_usecase.dart';
import 'package:sys_control/features/settings/domain/usecases/watch_setting_items_usecase.dart';
import 'package:sys_control/features/settings/ui/providers/app_settings_provider.dart';
import 'package:sys_control/features/settings/ui/states/settings_items_state.dart';

final settingsItemsProvider =
    NotifierProvider.autoDispose.family<SettingsItemsNotifier, SettingsItemsState, int>(
  SettingsItemsNotifier.new,
);

class SettingsItemsNotifier extends Notifier<SettingsItemsState> {
  SettingsItemsNotifier(this.categoryId);

  final int categoryId;

  StreamSubscription<Either<Failure, List<SettingItemEntity>>>? _subscription;

  @override
  SettingsItemsState build() {
    final useCase = ref.watch(watchSettingItemsUseCaseProvider);
    _subscription = useCase(categoryId).listen(
      (result) {
        result.fold(
          (failure) {
            state = state.copyWith(isLoading: false);
          },
          (items) {
            state = state.copyWith(items: items, isLoading: false);
          },
        );
      },
    );
    ref.onDispose(() => _subscription?.cancel());
    return SettingsItemsState.initial();
  }

  Future<bool> saveValue(String key, String value) async {
    final useCase = ref.read(saveSettingValueUseCaseProvider);
    final result = await useCase(key, value);

    return result.fold(
      (failure) {
        debugPrint('Failed to save setting value: $failure');
        return false;
      },
      (_) {
        switch (key) {
          case 'theme_mode':
            final index = (int.tryParse(value) ?? 0).clamp(0, ThemeMode.values.length - 1);
            ref.read(themeProvider.notifier).updateMode(ThemeMode.values[index]);
          case 'temperature_unit':
            final unit = TemperatureUnitEnum.tryFromName(value);
            if (unit != null) {
              ref.read(appSettingsProvider.notifier).updateTemperatureUnit(unit);
            }
          case 'language':
            final language = LanguageEnum.tryFromName(value);
            if (language != null) {
              ref.read(appSettingsProvider.notifier).updateLanguage(language);
            }
        }
        return true;
      },
    );
  }

  Future<void> resetCategory() async {
    final useCase = ref.read(resetSettingValuesUseCaseProvider);
    final result = await useCase(categoryId: categoryId);
    result.fold(
      (failure) => debugPrint('Failed to reset setting values: $failure'),
      (_) {},
    );
  }
}
