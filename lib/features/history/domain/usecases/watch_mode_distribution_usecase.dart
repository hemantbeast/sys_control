import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/history/data/repositories/history_repository_impl.dart';
import 'package:sys_control/features/history/domain/entities/mode_usage_entity.dart';
import 'package:sys_control/features/history/domain/repositories/history_repository.dart';

final watchModeDistributionUseCaseProvider = Provider<WatchModeDistributionUseCase>((ref) {
  return WatchModeDistributionUseCase(ref.read(historyRepositoryProvider));
});

class WatchModeDistributionUseCase {
  const WatchModeDistributionUseCase(this._repository);

  final HistoryRepository _repository;

  Stream<Either<Failure, List<ModeUsageEntity>>> call() async* {
    try {
      await for (final data in _repository.watchModeDistribution()) {
        yield right(data);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
