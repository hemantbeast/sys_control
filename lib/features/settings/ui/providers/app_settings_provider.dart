import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/settings/domain/entities/settings_entity.dart';
import 'package:sys_control/features/settings/domain/enums/language_enum.dart';
import 'package:sys_control/features/settings/domain/enums/temperature_unit_enum.dart';
import 'package:sys_control/features/settings/domain/usecases/watch_setting_value_usecase.dart';

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, SettingsEntity>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<SettingsEntity> {
  @override
  SettingsEntity build() {
    final useCase = ref.watch(watchSettingValueUseCaseProvider);
    final subscriptions = <StreamSubscription<Either<Failure, String?>>>[
      useCase('temperature_unit').listen((result) {
        result.fold(
          (failure) => debugPrint('Failed to watch temperature_unit: $failure'),
          (value) {
            final unit = value == null ? null : TemperatureUnitEnum.tryFromName(value);
            if (unit != null) {
              state = state.copyWith(temperatureUnit: unit);
            }
          },
        );
      }),
      useCase('language').listen((result) {
        result.fold(
          (failure) => debugPrint('Failed to watch language: $failure'),
          (value) {
            final language = value == null ? null : LanguageEnum.tryFromName(value);
            if (language != null) {
              state = state.copyWith(language: language);
            }
          },
        );
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
