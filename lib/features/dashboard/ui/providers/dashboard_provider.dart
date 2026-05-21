import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/dashboard/ui/states/dashboard_state.dart';

final dashboardProvider = NotifierProvider.autoDispose<DashboardNotifier, DashboardState>(DashboardNotifier.new);

class DashboardNotifier extends Notifier<DashboardState> {
  StreamSubscription<EnergyEntity>? _energySubscription;
  StreamSubscription<List<ZoneEntity>>? _zonesSubscription;

  @override
  DashboardState build() {
    ref.onDispose(() {
      _energySubscription?.cancel();
      _zonesSubscription?.cancel();
    });

    _setupStreams();
    return DashboardState.initial();
  }

  void _setupStreams() {
    final repository = ref.read(dashboardRepositoryProvider);

    _energySubscription = repository.watchEnergy().listen((entity) {
      state = state.copyWith(energy: entity);
    });

    _zonesSubscription = repository.watchZones().listen((data) {
      state = state.copyWith(zones: data);
    });
  }

  void setCurrentMode(ModeEnum mode) {
    state = state.copyWith(currentMode: mode);
  }

  void increaseTemp() {
    state = state.copyWith(targetTemp: math.min(35, state.targetTemp + 1));
  }

  void decreaseTemp() {
    state = state.copyWith(targetTemp: math.max(15, state.targetTemp - 1));
  }

  void setTargetTemp(double temp) {
    state = state.copyWith(targetTemp: temp.clamp(15, 35));
  }

  void setFanSpeed(FanSpeedEnum fanSpeed) {
    state = state.copyWith(fanSpeed: fanSpeed);
  }

  void togglePower() {
    state = state.copyWith(isOn: !state.isOn);
  }
}
