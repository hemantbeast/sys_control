import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/history/domain/usecases/watch_energy_cost_usecase.dart';
import 'package:sys_control/features/history/domain/usecases/watch_energy_usage_usecase.dart';
import 'package:sys_control/features/history/domain/usecases/watch_humidity_history_usecase.dart';
import 'package:sys_control/features/history/domain/usecases/watch_mode_distribution_usecase.dart';
import 'package:sys_control/features/history/domain/usecases/watch_schedule_activity_usecase.dart';
import 'package:sys_control/features/history/domain/usecases/watch_temperature_history_usecase.dart';
import 'package:sys_control/features/history/domain/usecases/watch_zone_comparison_usecase.dart';
import 'package:sys_control/features/history/ui/enums/energy_time_range.dart';
import 'package:sys_control/features/history/ui/enums/history_time_range.dart';
import 'package:sys_control/features/history/ui/states/history_state.dart';

final historyProvider = NotifierProvider.autoDispose<HistoryNotifier, HistoryState>(
  HistoryNotifier.new,
);

class HistoryNotifier extends Notifier<HistoryState> {
  @override
  HistoryState build() {
    _loadAll();
    return HistoryState.initial();
  }

  void _loadAll() {
    final tempSub = ref.read(watchTemperatureHistoryUseCaseProvider)().listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch temperature history: $failure'),
        (data) => state = state.copyWith(temperatureHistory: data, isLoading: false),
      );
    });

    final energySub = ref.read(watchEnergyUsageUseCaseProvider)(monthly: true).listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch energy usage: $failure'),
        (data) => state = state.copyWith(energyUsage: data),
      );
    });

    final costSub = ref.read(watchEnergyCostUseCaseProvider)().listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch energy cost: $failure'),
        (data) => state = state.copyWith(energyCost: data),
      );
    });

    final humiditySub = ref.read(watchHumidityHistoryUseCaseProvider)().listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch humidity history: $failure'),
        (data) => state = state.copyWith(humidityHistory: data),
      );
    });

    final modeSub = ref.read(watchModeDistributionUseCaseProvider)().listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch mode distribution: $failure'),
        (data) => state = state.copyWith(modeDistribution: data),
      );
    });

    final zoneSub = ref.read(watchZoneComparisonUseCaseProvider)().listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch zone comparison: $failure'),
        (data) => state = state.copyWith(zoneComparison: data),
      );
    });

    final scheduleSub = ref.read(watchScheduleActivityUseCaseProvider)().listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch schedule activity: $failure'),
        (data) => state = state.copyWith(scheduleActivity: data),
      );
    });

    ref.onDispose(() {
      tempSub.cancel();
      energySub.cancel();
      costSub.cancel();
      humiditySub.cancel();
      modeSub.cancel();
      zoneSub.cancel();
      scheduleSub.cancel();
    });
  }

  void setTimeRange(HistoryTimeRange range) {
    state = state.copyWith(selectedTimeRange: range);
  }

  void setEnergyRange(EnergyTimeRange range) {
    state = state.copyWith(selectedEnergyRange: range);
    final sub = ref.read(watchEnergyUsageUseCaseProvider)(monthly: range == EnergyTimeRange.monthly).listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch energy usage: $failure'),
        (data) => state = state.copyWith(energyUsage: data),
      );
    });
    ref.onDispose(sub.cancel);
  }
}
