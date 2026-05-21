import 'package:sys_control/features/history/domain/entities/energy_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/history_point_entity.dart';
import 'package:sys_control/features/history/domain/entities/mode_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/schedule_activity_entity.dart';
import 'package:sys_control/features/history/domain/entities/temperature_history_entity.dart';
import 'package:sys_control/features/history/domain/entities/zone_comparison_entity.dart';

abstract class HistoryRepository {
  Stream<TemperatureHistoryEntity> watchTemperatureHistory();
  Stream<EnergyUsageEntity> watchEnergyUsage({required bool monthly});
  Stream<List<HistoryPointEntity>> watchEnergyCost();
  Stream<List<HistoryPointEntity>> watchHumidityHistory();
  Stream<List<ModeUsageEntity>> watchModeDistribution();
  Stream<List<ZoneComparisonEntity>> watchZoneComparison();
  Stream<List<ScheduleActivityEntity>> watchScheduleActivity();
}
