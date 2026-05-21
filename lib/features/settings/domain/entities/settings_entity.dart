import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/settings/domain/enums/currency_enum.dart';
import 'package:sys_control/features/settings/domain/enums/language_enum.dart';
import 'package:sys_control/features/settings/domain/enums/temperature_unit_enum.dart';

class SettingsEntity {
  const SettingsEntity({
    required this.temperatureUnit,
    required this.language,
    required this.minTemp,
    required this.maxTemp,
    required this.defaultMode,
    required this.defaultFanSpeed,
    required this.defaultTargetTemp,
    required this.energyRate,
    required this.currency,
  });

  final TemperatureUnitEnum temperatureUnit;
  final LanguageEnum language;
  final double minTemp;
  final double maxTemp;
  final ModeEnum defaultMode;
  final FanSpeedEnum defaultFanSpeed;
  final double defaultTargetTemp;
  final double energyRate;
  final CurrencyEnum currency;

  SettingsEntity copyWith({
    TemperatureUnitEnum? temperatureUnit,
    LanguageEnum? language,
    double? minTemp,
    double? maxTemp,
    ModeEnum? defaultMode,
    FanSpeedEnum? defaultFanSpeed,
    double? defaultTargetTemp,
    double? energyRate,
    CurrencyEnum? currency,
  }) {
    return SettingsEntity(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      language: language ?? this.language,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
      defaultMode: defaultMode ?? this.defaultMode,
      defaultFanSpeed: defaultFanSpeed ?? this.defaultFanSpeed,
      defaultTargetTemp: defaultTargetTemp ?? this.defaultTargetTemp,
      energyRate: energyRate ?? this.energyRate,
      currency: currency ?? this.currency,
    );
  }

  factory SettingsEntity.defaults() => const SettingsEntity(
        temperatureUnit: TemperatureUnitEnum.celsius,
        language: LanguageEnum.english,
        minTemp: 15.0,
        maxTemp: 35.0,
        defaultMode: ModeEnum.auto,
        defaultFanSpeed: FanSpeedEnum.auto,
        defaultTargetTemp: 25.0,
        energyRate: 0.15,
        currency: CurrencyEnum.usd,
      );
}