import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sys_control/features/history/domain/entities/energy_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/history_point_entity.dart';
import 'package:sys_control/features/history/domain/entities/mode_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/schedule_activity_entity.dart';
import 'package:sys_control/features/history/domain/entities/temperature_history_entity.dart';
import 'package:sys_control/features/history/domain/entities/zone_comparison_entity.dart';
import 'package:sys_control/features/history/ui/enums/energy_time_range.dart';
import 'package:sys_control/features/history/ui/enums/history_time_range.dart';

part 'history_state.freezed.dart';

@freezed
abstract class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default(TemperatureHistoryEntity(indoor: [], target: [])) TemperatureHistoryEntity temperatureHistory,
    @Default(EnergyUsageEntity(thisYear: [], lastYear: [], labels: [])) EnergyUsageEntity energyUsage,
    @Default([]) List<HistoryPointEntity> energyCost,
    @Default([]) List<HistoryPointEntity> humidityHistory,
    @Default([]) List<ModeUsageEntity> modeDistribution,
    @Default([]) List<ZoneComparisonEntity> zoneComparison,
    @Default([]) List<ScheduleActivityEntity> scheduleActivity,
    @Default(HistoryTimeRange.hourly) HistoryTimeRange selectedTimeRange,
    @Default(EnergyTimeRange.monthly) EnergyTimeRange selectedEnergyRange,
    @Default(true) bool isLoading,
  }) = _HistoryState;

  factory HistoryState.initial() => const HistoryState();
}
