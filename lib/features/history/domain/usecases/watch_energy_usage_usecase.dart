import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/history/data/repositories/history_repository_impl.dart';
import 'package:sys_control/features/history/domain/entities/energy_usage_entity.dart';
import 'package:sys_control/features/history/domain/repositories/history_repository.dart';

final watchEnergyUsageUseCaseProvider = Provider<WatchEnergyUsageUseCase>((ref) {
  return WatchEnergyUsageUseCase(ref.read(historyRepositoryProvider));
});

class WatchEnergyUsageUseCase {
  const WatchEnergyUsageUseCase(this._repository);

  final HistoryRepository _repository;

  Stream<Either<Failure, EnergyUsageEntity>> call({required bool monthly}) async* {
    try {
      await for (final data in _repository.watchEnergyUsage(monthly: monthly)) {
        yield right(data);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
