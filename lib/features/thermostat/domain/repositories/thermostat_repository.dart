import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/thermostat/domain/entities/thermostat_entity.dart';

abstract class ThermostatRepository {
  Stream<ThermostatEntity> watchThermostat();

  Future<void> updateMode(ModeEnum mode);

  Future<void> updateFanSpeed(FanSpeedEnum fanSpeed);

  Future<void> updateTargetTemp(double temp);
}
