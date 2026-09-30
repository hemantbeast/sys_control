import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sys_control/features/dashboard/domain/entities/device_state_entity.dart';
import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/dashboard/domain/usecases/update_device_state_usecase.dart';
import 'package:sys_control/features/dashboard/domain/usecases/watch_device_state_usecase.dart';
import 'package:sys_control/features/dashboard/ui/states/dashboard_state.dart';

const String kIduUnitId = 'IDU-1';
const String kOduUnitId = 'ODU-1';

final dashboardProvider = NotifierProvider.autoDispose<DashboardNotifier, DashboardState>(DashboardNotifier.new);

class DashboardNotifier extends Notifier<DashboardState> {
  StreamSubscription<EnergyEntity>? _energySubscription;
  StreamSubscription<List<ZoneEntity>>? _zonesSubscription;
  StreamSubscription<List<DeviceStateEntity>>? _deviceSubscription;

  @override
  DashboardState build() {
    ref.onDispose(() {
      _energySubscription?.cancel();
      _zonesSubscription?.cancel();
      _deviceSubscription?.cancel();
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

    _deviceSubscription = ref.read(watchDeviceStateUseCaseProvider)().listen((devices) {
      for (final device in devices) {
        if (device.unitId == kIduUnitId) {
          state = state.copyWith(
            indoorTemp: device.temperature,
            targetTemp: device.targetTemp,
            currentMode: _modeFromName(device.mode),
            fanSpeed: _fanFromName(device.fanSpeed),
            isOn: device.isOn,
          );
        } else if (device.unitId == kOduUnitId) {
          final energy = state.energy;
          state = state.copyWith(
            energy: EnergyEntity(
              cost: energy.cost,
              efficiency: energy.efficiency,
              usage: energy.usage,
              outdoorTemp: device.temperature,
            ),
          );
        }
      }
    });
  }

  void setCurrentMode(ModeEnum mode) {
    state = state.copyWith(currentMode: mode);
    _write(mode: mode.name);
  }

  void increaseTemp() {
    setTargetTemp(state.targetTemp + 1);
  }

  void decreaseTemp() {
    setTargetTemp(state.targetTemp - 1);
  }

  void setTargetTemp(double temp) {
    final clamped = temp.clamp(15.0, 35.0).toDouble();
    state = state.copyWith(targetTemp: clamped);
    _write(targetTemp: clamped);
  }

  void setFanSpeed(FanSpeedEnum fanSpeed) {
    state = state.copyWith(fanSpeed: fanSpeed);
    _write(fanSpeed: fanSpeed.name);
  }

  void togglePower() {
    final isOn = !state.isOn;
    state = state.copyWith(isOn: isOn);
    _write(isOn: isOn);
  }

  void _write({double? targetTemp, String? mode, String? fanSpeed, bool? isOn}) {
    ref.read(updateDeviceStateUseCaseProvider)(kIduUnitId, 'IDU', targetTemp: targetTemp, mode: mode, fanSpeed: fanSpeed, isOn: isOn);
  }

  static ModeEnum _modeFromName(String name) {
    for (final mode in ModeEnum.values) {
      if (mode.name == name.toLowerCase()) {
        return mode;
      }
    }
    return ModeEnum.auto;
  }

  static FanSpeedEnum _fanFromName(String name) {
    for (final fan in FanSpeedEnum.values) {
      if (fan.name == name.toLowerCase()) {
        return fan;
      }
    }
    return FanSpeedEnum.auto;
  }
}
