import 'package:sys_control/features/settings/domain/entities/settings_entity.dart';

abstract class SettingsRepository {
  Stream<SettingsEntity> watchSettings();
  Future<void> saveSettings(SettingsEntity settings);
  Future<SettingsEntity> getSettings();
}