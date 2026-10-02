import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:sys_control/features/schedules/domain/repositories/schedule_repository.dart';

final toggleScheduleEnabledUseCaseProvider = Provider<ToggleScheduleEnabledUseCase>((ref) {
  return ToggleScheduleEnabledUseCase(ref.read(scheduleRepositoryProvider));
});

class ToggleScheduleEnabledUseCase {
  const ToggleScheduleEnabledUseCase(this._repository);

  final ScheduleRepository _repository;

  Future<Either<Failure, Unit>> call(int id, {required bool isEnabled}) async {
    try {
      await _repository.toggleEnabled(id, isEnabled: isEnabled);
      return right(unit);
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
