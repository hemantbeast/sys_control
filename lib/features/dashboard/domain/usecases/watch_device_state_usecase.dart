import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/dashboard/data/repositories/device_state_repository_impl.dart';
import 'package:sys_control/features/dashboard/domain/entities/device_state_entity.dart';
import 'package:sys_control/features/dashboard/domain/repositories/device_state_repository.dart';

final watchDeviceStateUseCaseProvider = Provider<WatchDeviceStateUseCase>((ref) {
  return WatchDeviceStateUseCase(ref.read(deviceStateRepositoryProvider));
});

class WatchDeviceStateUseCase {
  const WatchDeviceStateUseCase(this._repository);

  final DeviceStateRepository _repository;

  Stream<Either<Failure, List<DeviceStateEntity>>> call() async* {
    try {
      await for (final devices in _repository.watchDevices()) {
        yield right(devices);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
