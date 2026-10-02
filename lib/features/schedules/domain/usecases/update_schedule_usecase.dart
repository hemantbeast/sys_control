import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/repositories/schedule_repository.dart';

final updateScheduleUseCaseProvider = Provider<UpdateScheduleUseCase>((ref) {
  return UpdateScheduleUseCase(ref.read(scheduleRepositoryProvider));
});

class UpdateScheduleUseCase {
  const UpdateScheduleUseCase(this._repository);

  final ScheduleRepository _repository;

  Future<Either<Failure, Unit>> call(ScheduleEntity schedule) async {
    try {
      await _repository.update(schedule);
      return right(unit);
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
