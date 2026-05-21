import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/thermostat/data/models/thermostat_model.dart';
import 'package:sys_control/features/thermostat/data/sources/local/thermostat_local.dart';
import 'package:sys_control/features/thermostat/data/sources/remote/thermostat_service.dart';
import 'package:sys_control/features/thermostat/domain/entities/thermostat_entity.dart';
import 'package:sys_control/features/thermostat/domain/repositories/thermostat_repository.dart';

final thermostatRepositoryProvider = Provider<ThermostatRepository>((ref) {
  final service = ref.read(thermostatRemoteProvider);
  final local = ref.read(thermostatLocalProvider);

  return ThermostatRepositoryImpl(ref: ref, service: service, local: local);
});

class ThermostatRepositoryImpl extends ThermostatRepository {
  ThermostatRepositoryImpl({
    required this.ref,
    required this.service,
    required this.local,
  });

  final Ref ref;

  final ThermostatService service;

  final ThermostatLocal local;

  @override
  Stream<ThermostatEntity> watchThermostat() async* {
    final localData = await local.get();

    if (localData != null) {
      yield localData.toEntity();
    }

    try {
      final data = await service.getThermostat();
      await local.save(data);

      yield data.toEntity();
    } on Exception catch (_) {
      if (localData == null) {
        rethrow;
      }
    }
  }

  @override
  Future<void> updateMode(ModeEnum mode) async {
    await service.updateMode(mode.index);

    final cached = await local.get();
    if (cached != null) {
      await local.save(
        ThermostatModel(
          targetTemp: cached.targetTemp,
          indoorTemp: cached.indoorTemp,
          humidity: cached.humidity,
          mode: mode.index,
          fanSpeed: cached.fanSpeed,
          isOn: cached.isOn,
        ),
      );
    }
  }

  @override
  Future<void> updateFanSpeed(FanSpeedEnum fanSpeed) async {
    await service.updateFanSpeed(fanSpeed.index);

    final cached = await local.get();
    if (cached != null) {
      await local.save(
        ThermostatModel(
          targetTemp: cached.targetTemp,
          indoorTemp: cached.indoorTemp,
          humidity: cached.humidity,
          mode: cached.mode,
          fanSpeed: fanSpeed.index,
          isOn: cached.isOn,
        ),
      );
    }
  }

  @override
  Future<void> updateTargetTemp(double temp) async {
    await service.updateTargetTemp(temp);

    final cached = await local.get();
    if (cached != null) {
      await local.save(
        ThermostatModel(
          targetTemp: temp,
          indoorTemp: cached.indoorTemp,
          humidity: cached.humidity,
          mode: cached.mode,
          fanSpeed: cached.fanSpeed,
          isOn: cached.isOn,
        ),
      );
    }
  }
}
