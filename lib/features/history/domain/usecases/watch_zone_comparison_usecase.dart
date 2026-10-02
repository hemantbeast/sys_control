import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/history/data/repositories/history_repository_impl.dart';
import 'package:sys_control/features/history/domain/entities/zone_comparison_entity.dart';
import 'package:sys_control/features/history/domain/repositories/history_repository.dart';

final watchZoneComparisonUseCaseProvider = Provider<WatchZoneComparisonUseCase>((ref) {
  return WatchZoneComparisonUseCase(ref.read(historyRepositoryProvider));
});

class WatchZoneComparisonUseCase {
  const WatchZoneComparisonUseCase(this._repository);

  final HistoryRepository _repository;

  Stream<Either<Failure, List<ZoneComparisonEntity>>> call() async* {
    try {
      await for (final data in _repository.watchZoneComparison()) {
        yield right(data);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
