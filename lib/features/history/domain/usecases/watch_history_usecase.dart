import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/history/data/repositories/history_repository_impl.dart';
import 'package:sys_control/features/history/domain/entities/energy_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/history_point_entity.dart';
import 'package:sys_control/features/history/domain/entities/mode_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/schedule_activity_entity.dart';
import 'package:sys_control/features/history/domain/entities/temperature_history_entity.dart';
import 'package:sys_control/features/history/domain/entities/zone_comparison_entity.dart';
import 'package:sys_control/features/history/domain/repositories/history_repository.dart';

final watchHistoryUseCaseProvider = Provider<WatchHistoryUsecase>((ref) {
  return WatchHistoryUsecase(ref.read(historyRepositoryProvider));
});

class WatchHistoryUsecase {
  const WatchHistoryUsecase(this._repository);

  final HistoryRepository _repository;

  Stream<TemperatureHistoryEntity> watchTemperatureHistory() {
    return _repository.watchTemperatureHistory();
  }

  Stream<EnergyUsageEntity> watchEnergyUsage({required bool monthly}) {
    return _repository.watchEnergyUsage(monthly: monthly);
  }

  Stream<List<HistoryPointEntity>> watchEnergyCost() {
    return _repository.watchEnergyCost();
  }

  Stream<List<HistoryPointEntity>> watchHumidityHistory() {
    return _repository.watchHumidityHistory();
  }

  Stream<List<ModeUsageEntity>> watchModeDistribution() {
    return _repository.watchModeDistribution();
  }

  Stream<List<ZoneComparisonEntity>> watchZoneComparison() {
    return _repository.watchZoneComparison();
  }

  Stream<List<ScheduleActivityEntity>> watchScheduleActivity() {
    return _repository.watchScheduleActivity();
  }
}
