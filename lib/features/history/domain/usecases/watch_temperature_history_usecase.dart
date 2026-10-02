import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/history/data/repositories/history_repository_impl.dart';
import 'package:sys_control/features/history/domain/entities/temperature_history_entity.dart';
import 'package:sys_control/features/history/domain/repositories/history_repository.dart';

final watchTemperatureHistoryUseCaseProvider = Provider<WatchTemperatureHistoryUseCase>((ref) {
  return WatchTemperatureHistoryUseCase(ref.read(historyRepositoryProvider));
});

class WatchTemperatureHistoryUseCase {
  const WatchTemperatureHistoryUseCase(this._repository);

  final HistoryRepository _repository;

  Stream<Either<Failure, TemperatureHistoryEntity>> call() async* {
    try {
      await for (final data in _repository.watchTemperatureHistory()) {
        yield right(data);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
