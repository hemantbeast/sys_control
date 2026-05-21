import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/settings/domain/entities/settings_entity.dart';
import 'package:sys_control/features/settings/domain/enums/language_enum.dart';
import 'package:sys_control/features/settings/domain/enums/temperature_unit_enum.dart';
import 'package:sys_control/features/settings/domain/usecases/get_setting_value_usecase.dart';

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, SettingsEntity>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<SettingsEntity> {
  @override
  SettingsEntity build() {
    Future.microtask(_restorePersisted);
    return SettingsEntity.defaults();
  }

  void updateTemperatureUnit(TemperatureUnitEnum unit) {
    state = state.copyWith(temperatureUnit: unit);
  }

  void updateLanguage(LanguageEnum language) {
    state = state.copyWith(language: language);
  }

  Future<void> _restorePersisted() async {
    final useCase = ref.read(getSettingValueUseCaseProvider);

    final unitValue = await useCase('temperature_unit');
    final languageValue = await useCase('language');

    if (unitValue != null) {
      final unit = TemperatureUnitEnum.tryFromName(unitValue);
      if (unit != null) {
        state = state.copyWith(temperatureUnit: unit);
      }
    }

    if (languageValue != null) {
      final language = LanguageEnum.tryFromName(languageValue);
      if (language != null) {
        state = state.copyWith(language: language);
      }
    }
  }
}
