import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/history/domain/usecases/watch_history_usecase.dart';
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
    final useCase = ref.read(watchHistoryUseCaseProvider);

    final tempSub = useCase.watchTemperatureHistory().listen((data) {
      state = state.copyWith(temperatureHistory: data, isLoading: false);
    });

    final energySub = useCase.watchEnergyUsage(monthly: true).listen((data) {
      state = state.copyWith(energyUsage: data);
    });

    final costSub = useCase.watchEnergyCost().listen((data) {
      state = state.copyWith(energyCost: data);
    });

    final humiditySub = useCase.watchHumidityHistory().listen((data) {
      state = state.copyWith(humidityHistory: data);
    });

    final modeSub = useCase.watchModeDistribution().listen((data) {
      state = state.copyWith(modeDistribution: data);
    });

    final zoneSub = useCase.watchZoneComparison().listen((data) {
      state = state.copyWith(zoneComparison: data);
    });

    final scheduleSub = useCase.watchScheduleActivity().listen((data) {
      state = state.copyWith(scheduleActivity: data);
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
    final useCase = ref.read(watchHistoryUseCaseProvider);
    final sub = useCase.watchEnergyUsage(monthly: range == EnergyTimeRange.monthly).listen((data) {
      state = state.copyWith(energyUsage: data);
    });
    ref.onDispose(sub.cancel);
  }
}
