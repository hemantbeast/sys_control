import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/repositories/schedule_repository.dart';

final watchSchedulesUseCaseProvider = Provider<WatchSchedulesUseCase>((ref) {
  return WatchSchedulesUseCase(ref.read(scheduleRepositoryProvider));
});

class WatchSchedulesUseCase {
  const WatchSchedulesUseCase(this._repository);

  final ScheduleRepository _repository;

  Stream<Either<Failure, List<ScheduleEntity>>> call() async* {
    try {
      await for (final schedules in _repository.watchAll()) {
        yield right(schedules);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
