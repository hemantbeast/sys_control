import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

part 'thermostat_state.freezed.dart';

@freezed
abstract class ThermostatState with _$ThermostatState {
  const factory ThermostatState({
    @Default(24.0) double targetTemp,
    @Default(22.0) double indoorTemp,
    @Default(50.0) double humidity,
    @Default(ModeEnum.auto) ModeEnum mode,
    @Default(FanSpeedEnum.auto) FanSpeedEnum fanSpeed,
    @Default(false) bool isOn,
    @Default(false) bool isLoading,
  }) = _ThermostatState;

  factory ThermostatState.initial() => const ThermostatState();
}
