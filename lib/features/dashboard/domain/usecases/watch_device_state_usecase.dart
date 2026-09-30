import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/data/repositories/device_state_repository_impl.dart';
import 'package:sys_control/features/dashboard/domain/entities/device_state_entity.dart';
import 'package:sys_control/features/dashboard/domain/repositories/device_state_repository.dart';

final watchDeviceStateUseCaseProvider = Provider<WatchDeviceStateUseCase>((ref) {
  return WatchDeviceStateUseCase(ref.read(deviceStateRepositoryProvider));
});

class WatchDeviceStateUseCase {
  const WatchDeviceStateUseCase(this._repository);

  final DeviceStateRepository _repository;

  Stream<List<DeviceStateEntity>> call() {
    return _repository.watchDevices();
  }
}
