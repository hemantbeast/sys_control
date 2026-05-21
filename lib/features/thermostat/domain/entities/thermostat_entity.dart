import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

class ThermostatEntity {
  ThermostatEntity({
    required this.targetTemp,
    required this.indoorTemp,
    required this.humidity,
    required this.mode,
    required this.fanSpeed,
    required this.isOn,
  });

  final double targetTemp;

  final double indoorTemp;

  final double humidity;

  final ModeEnum mode;

  final FanSpeedEnum fanSpeed;

  final bool isOn;
}
