import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/history/data/mock/history_mock_data.dart';
import 'package:sys_control/features/history/domain/entities/energy_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/history_point_entity.dart';
import 'package:sys_control/features/history/domain/entities/mode_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/schedule_activity_entity.dart';
import 'package:sys_control/features/history/domain/entities/temperature_history_entity.dart';
import 'package:sys_control/features/history/domain/entities/zone_comparison_entity.dart';
import 'package:sys_control/features/history/domain/repositories/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl();
});

class HistoryRepositoryImpl implements HistoryRepository {
  @override
  Stream<TemperatureHistoryEntity> watchTemperatureHistory() async* {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    yield HistoryMockData.temperatureHistory();
  }

  @override
  Stream<EnergyUsageEntity> watchEnergyUsage({required bool monthly}) async* {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (monthly) {
      yield HistoryMockData.energyUsageMonthly();
    } else {
      yield HistoryMockData.energyUsageWeekly();
    }
  }

  @override
  Stream<List<HistoryPointEntity>> watchEnergyCost() async* {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    yield HistoryMockData.energyCost();
  }

  @override
  Stream<List<HistoryPointEntity>> watchHumidityHistory() async* {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    yield HistoryMockData.humidityHistory();
  }

  @override
  Stream<List<ModeUsageEntity>> watchModeDistribution() async* {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    yield HistoryMockData.modeDistribution();
  }

  @override
  Stream<List<ZoneComparisonEntity>> watchZoneComparison() async* {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    yield HistoryMockData.zoneComparison();
  }

  @override
  Stream<List<ScheduleActivityEntity>> watchScheduleActivity() async* {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    yield HistoryMockData.scheduleActivity();
  }
}
