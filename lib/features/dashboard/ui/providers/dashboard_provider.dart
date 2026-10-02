import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/dashboard/domain/entities/device_state_entity.dart';
import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/dashboard/domain/usecases/count_devices_usecase.dart';
import 'package:sys_control/features/dashboard/domain/usecases/update_device_state_usecase.dart';
import 'package:sys_control/features/dashboard/domain/usecases/watch_device_state_usecase.dart';
import 'package:sys_control/features/dashboard/domain/usecases/watch_energy_usecase.dart';
import 'package:sys_control/features/dashboard/domain/usecases/watch_zones_usecase.dart';
import 'package:sys_control/features/dashboard/ui/states/dashboard_state.dart';

const String kIduUnitId = 'IDU-1';
const String kOduUnitId = 'ODU-1';

final dashboardProvider = NotifierProvider.autoDispose<DashboardNotifier, DashboardState>(DashboardNotifier.new);

class DashboardNotifier extends Notifier<DashboardState> {
  StreamSubscription<Either<Failure, EnergyEntity>>? _energySubscription;
  StreamSubscription<Either<Failure, List<ZoneEntity>>>? _zonesSubscription;
  StreamSubscription<Either<Failure, List<DeviceStateEntity>>>? _deviceSubscription;

  @override
  DashboardState build() {
    // Rebuild (and re-subscribe) when the database is recreated after a file
    // replacement; _setupStreams then swaps onto the live AppDatabase.
    ref.watch(watchDeviceStateUseCaseProvider);
    ref.onDispose(() {
      _energySubscription?.cancel();
      _zonesSubscription?.cancel();
      _deviceSubscription?.cancel();
    });

    _setupStreams();
    return DashboardState.initial();
  }

  void _setupStreams() {
    _energySubscription?.cancel();
    _zonesSubscription?.cancel();
    _deviceSubscription?.cancel();

    _energySubscription = ref.read(watchEnergyUseCaseProvider)().listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch energy: $failure'),
        (entity) => state = state.copyWith(energy: entity),
      );
    });

    _zonesSubscription = ref.read(watchZonesUseCaseProvider)().listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch zones: $failure'),
        (data) => state = state.copyWith(zones: data),
      );
    });

    _seedInitialDevices();

    _deviceSubscription = ref.read(watchDeviceStateUseCaseProvider)().listen((result) {
      result.fold(
        (failure) => debugPrint('Failed to watch device state: $failure'),
        (devices) {
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
        },
      );
    });
  }

  /// Mirrors the Qt scheduler's `DashboardBackend::ensureIduRow`: if the shared
  /// `device_state` table is empty, seed the IDU-1 and ODU-1 rows so the
  /// thermostat has live data to display on first run.
  Future<void> _seedInitialDevices() async {
    final count = await ref.read(countDevicesUseCaseProvider)();
    final isEmpty = count.fold((failure) {
      debugPrint('Failed to count devices: $failure');
      return false;
    }, (value) => value == 0);
    if (!isEmpty) {
      return;
    }

    final useCase = ref.read(updateDeviceStateUseCaseProvider);
    await useCase(
      kIduUnitId,
      'IDU',
      targetTemp: 25,
      mode: 'auto',
      fanSpeed: 'auto',
      isOn: true,
      temperature: 20,
      humidity: 50,
    );
    await useCase(
      kOduUnitId,
      'ODU',
      temperature: 32,
    );
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
    ref.read(updateDeviceStateUseCaseProvider)(
      kIduUnitId,
      'IDU',
      targetTemp: targetTemp,
      mode: mode,
      fanSpeed: fanSpeed,
      isOn: isOn,
    ).then((result) {
      result.fold(
        (l) => debugPrint('Failed to update device state: $l'),
        (r) {},
      );
    });
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
