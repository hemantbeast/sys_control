import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

class ZoneEntity {
  ZoneEntity({
    required this.name,
    required this.fanSpeed,
    required this.humidity,
    required this.isEco,
    required this.isOn,
    required this.mode,
    required this.temp,
  });

  final String name;

  final bool isOn;

  final double temp;

  final double humidity;

  final bool isEco;

  final ModeEnum mode;

  final FanSpeedEnum fanSpeed;
}
