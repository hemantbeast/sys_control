import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/repositories/schedule_repository.dart';

final createScheduleUseCaseProvider = Provider<CreateScheduleUseCase>((ref) {
  return CreateScheduleUseCase(ref.read(scheduleRepositoryProvider));
});

class CreateScheduleUseCase {
  const CreateScheduleUseCase(this._repository);

  final ScheduleRepository _repository;

  Future<Either<Failure, int>> call(ScheduleEntity schedule) async {
    try {
      return right(await _repository.create(schedule));
    } on Object catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
