import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/thermostat/data/repositories/thermostat_repository_impl.dart';
import 'package:sys_control/features/thermostat/domain/entities/thermostat_entity.dart';
import 'package:sys_control/features/thermostat/domain/repositories/thermostat_repository.dart';

final watchThermostatUseCaseProvider = Provider<WatchThermostatUseCase>((ref) {
  return WatchThermostatUseCase(ref.read(thermostatRepositoryProvider));
});

final updateThermostatUseCaseProvider = Provider<UpdateThermostatUseCase>((ref) {
  return UpdateThermostatUseCase(ref.read(thermostatRepositoryProvider));
});

class WatchThermostatUseCase {
  WatchThermostatUseCase(this._repository);

  final ThermostatRepository _repository;

  Stream<ThermostatEntity> call() {
    return _repository.watchThermostat();
  }
}

class UpdateThermostatUseCase {
  UpdateThermostatUseCase(this._repository);

  final ThermostatRepository _repository;

  Future<void> updateMode(ModeEnum mode) => _repository.updateMode(mode);

  Future<void> updateFanSpeed(FanSpeedEnum fanSpeed) => _repository.updateFanSpeed(fanSpeed);

  Future<void> updateTargetTemp(double temp) => _repository.updateTargetTemp(temp);
}
