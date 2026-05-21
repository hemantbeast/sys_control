import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required EnergyEntity energy,
    @Default([]) List<ZoneEntity> zones,
    @Default(ModeEnum.auto) ModeEnum currentMode,
    @Default(FanSpeedEnum.auto) FanSpeedEnum fanSpeed,
    @Default(25.0) double targetTemp,
    @Default(20.0) double indoorTemp,
    @Default(false) bool isOn,
  }) = _DashboardState;

  factory DashboardState.initial() {
    return DashboardState(
      energy: EnergyEntity(cost: 0, efficiency: 0, usage: 0, outdoorTemp: 0),
    );
  }
}
