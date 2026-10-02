import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/dashboard/data/repositories/device_state_repository_impl.dart';
import 'package:sys_control/features/dashboard/domain/repositories/device_state_repository.dart';

final countDevicesUseCaseProvider = Provider<CountDevicesUseCase>((ref) {
  return CountDevicesUseCase(ref.read(deviceStateRepositoryProvider));
});

class CountDevicesUseCase {
  CountDevicesUseCase(this._repository);

  final DeviceStateRepository _repository;

  Future<Either<Failure, int>> call() async {
    try {
      return right(await _repository.countDevices());
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
