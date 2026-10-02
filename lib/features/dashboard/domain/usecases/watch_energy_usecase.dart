import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';
import 'package:sys_control/features/dashboard/domain/repositories/dashboard_repository.dart';

final watchEnergyUseCaseProvider = Provider<WatchEnergyUseCase>((ref) {
  return WatchEnergyUseCase(ref.read(dashboardRepositoryProvider));
});

class WatchEnergyUseCase {
  WatchEnergyUseCase(this._repository);

  final DashboardRepository _repository;

  Stream<Either<Failure, EnergyEntity>> call() async* {
    try {
      await for (final entity in _repository.watchEnergy()) {
        yield right(entity);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
