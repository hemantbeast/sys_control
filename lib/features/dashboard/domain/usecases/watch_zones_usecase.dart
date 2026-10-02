import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/domain/repositories/dashboard_repository.dart';

final watchZonesUseCaseProvider = Provider<WatchZonesUseCase>((ref) {
  return WatchZonesUseCase(ref.read(dashboardRepositoryProvider));
});

class WatchZonesUseCase {
  WatchZonesUseCase(this._repository);

  final DashboardRepository _repository;

  Stream<Either<Failure, List<ZoneEntity>>> call() async* {
    try {
      await for (final zones in _repository.watchZones()) {
        yield right(zones);
      }
    } on Object catch (e) {
      yield left(UnexpectedFailure(e.toString()));
    }
  }
}
