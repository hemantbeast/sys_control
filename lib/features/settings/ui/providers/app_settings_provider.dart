import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/settings/domain/entities/settings_entity.dart';
import 'package:sys_control/features/settings/domain/enums/language_enum.dart';
import 'package:sys_control/features/settings/domain/enums/temperature_unit_enum.dart';
import 'package:sys_control/features/settings/domain/usecases/watch_setting_value_usecase.dart';

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, SettingsEntity>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<SettingsEntity> {
  @override
  SettingsEntity build() {
    final useCase = ref.watch(watchSettingValueUseCaseProvider);
    final subscriptions = <StreamSubscription<Object?>>[
      useCase('temperature_unit').listen((value) {
        final unit = value == null ? null : TemperatureUnitEnum.tryFromName(value);
        if (unit != null) {
          state = state.copyWith(temperatureUnit: unit);
        }
      }),
      useCase('language').listen((value) {
        final language = value == null ? null : LanguageEnum.tryFromName(value);
        if (language != null) {
          state = state.copyWith(language: language);
        }
      }),
    ];
    ref.onDispose(() {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    });
    return SettingsEntity.defaults();
  }

  void updateTemperatureUnit(TemperatureUnitEnum unit) {
    state = state.copyWith(temperatureUnit: unit);
  }

  void updateLanguage(LanguageEnum language) {
    state = state.copyWith(language: language);
  }
}
