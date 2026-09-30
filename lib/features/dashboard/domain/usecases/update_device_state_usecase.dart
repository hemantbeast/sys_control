import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/dashboard/data/repositories/device_state_repository_impl.dart';
import 'package:sys_control/features/dashboard/domain/repositories/device_state_repository.dart';

final updateDeviceStateUseCaseProvider = Provider<UpdateDeviceStateUseCase>((ref) {
  return UpdateDeviceStateUseCase(ref.read(deviceStateRepositoryProvider));
});

class UpdateDeviceStateUseCase {
  const UpdateDeviceStateUseCase(this._repository);

  final DeviceStateRepository _repository;

  Future<Either<Failure, Unit>> call(
    String unitId,
    String unitType, {
    double? targetTemp,
    String? mode,
    String? fanSpeed,
    bool? isOn,
    double? temperature,
    double? humidity,
  }) async {
    try {
      await _repository.writeFields(
        unitId,
        unitType,
        targetTemp: targetTemp,
        mode: mode,
        fanSpeed: fanSpeed,
        isOn: isOn,
        temperature: temperature,
        humidity: humidity,
      );
      return right(unit);
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
