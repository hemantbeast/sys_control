import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/history/data/repositories/history_repository_impl.dart';
import 'package:sys_control/features/history/domain/entities/schedule_activity_entity.dart';
import 'package:sys_control/features/history/domain/repositories/history_repository.dart';

final watchScheduleActivityUseCaseProvider = Provider<WatchScheduleActivityUseCase>((ref) {
  return WatchScheduleActivityUseCase(ref.read(historyRepositoryProvider));
});

class WatchScheduleActivityUseCase {
  const WatchScheduleActivityUseCase(this._repository);

  final HistoryRepository _repository;

  Stream<Either<Failure, List<ScheduleActivityEntity>>> call() async* {
    try {
      await for (final data in _repository.watchScheduleActivity()) {
        yield right(data);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
