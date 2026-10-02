import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/history/data/repositories/history_repository_impl.dart';
import 'package:sys_control/features/history/domain/entities/history_point_entity.dart';
import 'package:sys_control/features/history/domain/repositories/history_repository.dart';

final watchEnergyCostUseCaseProvider = Provider<WatchEnergyCostUseCase>((ref) {
  return WatchEnergyCostUseCase(ref.read(historyRepositoryProvider));
});

class WatchEnergyCostUseCase {
  const WatchEnergyCostUseCase(this._repository);

  final HistoryRepository _repository;

  Stream<Either<Failure, List<HistoryPointEntity>>> call() async* {
    try {
      await for (final data in _repository.watchEnergyCost()) {
        yield right(data);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
