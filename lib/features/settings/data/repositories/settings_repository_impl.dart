import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/settings/data/sources/local/settings_dao.dart';
import 'package:sys_control/features/settings/domain/entities/settings_entity.dart';
import 'package:sys_control/features/settings/domain/enums/currency_enum.dart';
import 'package:sys_control/features/settings/domain/enums/language_enum.dart';
import 'package:sys_control/features/settings/domain/enums/temperature_unit_enum.dart';
import 'package:sys_control/features/settings/domain/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.read(settingsDaoProvider));
});

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._dao);

  final SettingsDao _dao;

  @override
  Stream<SettingsEntity> watchSettings() {
    return _dao.watch().map(_toEntity);
  }

  @override
  Future<SettingsEntity> getSettings() async {
    return _toEntity(await _dao.get());
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    await _dao.upsert(
      SettingsTableCompanion(
        id: const drift.Value(1),
        temperatureUnit: drift.Value(settings.temperatureUnit.index),
        language: drift.Value(settings.language.code),
        minTemp: drift.Value(settings.minTemp),
        maxTemp: drift.Value(settings.maxTemp),
        defaultMode: drift.Value(settings.defaultMode.index),
        defaultFanSpeed: drift.Value(settings.defaultFanSpeed.index),
        defaultTargetTemp: drift.Value(settings.defaultTargetTemp),
        energyRate: drift.Value(settings.energyRate),
        currencySymbol: drift.Value(settings.currency.symbol),
      ),
    );
  }

  SettingsEntity _toEntity(SettingsTableData row) {
    return SettingsEntity(
      temperatureUnit: TemperatureUnitEnum.values[row.temperatureUnit.clamp(0, TemperatureUnitEnum.values.length - 1)],
      language: LanguageEnum.fromCode(row.language),
      minTemp: row.minTemp,
      maxTemp: row.maxTemp,
      defaultMode: ModeEnum.values[row.defaultMode.clamp(0, ModeEnum.values.length - 1)],
      defaultFanSpeed: FanSpeedEnum.values[row.defaultFanSpeed.clamp(0, FanSpeedEnum.values.length - 1)],
      defaultTargetTemp: row.defaultTargetTemp,
      energyRate: row.energyRate,
      currency: CurrencyEnum.fromSymbol(row.currencySymbol),
    );
  }
}