import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:sys_control/features/dashboard/domain/usecases/watch_energy_usecase.dart';

class _FakeDashboardRepository extends DashboardRepository {
  _FakeDashboardRepository({this.energy, this.error});

  final Stream<EnergyEntity>? energy;
  final Object? error;

  @override
  Stream<EnergyEntity> watchEnergy() {
    if (error != null) {
      return Stream.error(error!);
    }
    return energy!;
  }

  @override
  Stream<List<ZoneEntity>> watchZones() => const Stream.empty();
}

void main() {
  final entity = EnergyEntity(cost: 1, efficiency: 2, usage: 3, outdoorTemp: 4);

  test('call() yields Right with the repository data', () async {
    final useCase = WatchEnergyUseCase(_FakeDashboardRepository(energy: Stream.value(entity)));

    final result = await useCase().first;

    result.fold(
      (failure) => fail('expected Right, got $failure'),
      (value) => expect(value, same(entity)),
    );
  });

  test('call() yields Left(UnexpectedFailure) when the repository throws', () async {
    final useCase = WatchEnergyUseCase(_FakeDashboardRepository(error: StateError('boom')));

    final result = await useCase().first;

    result.fold(
      (failure) {
        expect(failure, isA<UnexpectedFailure>());
        expect(failure.message, contains('boom'));
      },
      (value) => fail('expected Left, got $value'),
    );
  });
}
