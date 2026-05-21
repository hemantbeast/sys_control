import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/data/sources/local/dashboard_local.dart';
import 'package:sys_control/features/dashboard/data/sources/remote/dashboard_service.dart';
import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/domain/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final service = ref.read(dashboardRemoteProvider);
  final local = ref.read(dashboardLocalProvider);

  return DashboardRepositoryImpl(ref: ref, service: service, local: local);
});

class DashboardRepositoryImpl extends DashboardRepository {
  DashboardRepositoryImpl({
    required this.ref,
    required this.service,
    required this.local,
  });

  final Ref ref;

  final DashboardService service;

  final DashboardLocal local;

  @override
  Stream<EnergyEntity> watchEnergy() async* {
    final localData = await local.getEnergy();

    if (localData != null) {
      yield localData.toEntity();
    }

    try {
      final data = await service.getEnergy();
      await local.saveEnergy(data);

      yield data.toEntity();
    } on Exception catch (_) {
      if (localData == null) {
        rethrow;
      }
    }
  }

  @override
  Stream<List<ZoneEntity>> watchZones() async* {
    final localData = await local.getZones();

    if (localData != null) {
      yield localData.map((e) => e.toEntity()).toList();
    }

    try {
      final data = await service.getZones();
      await local.saveZones(data);

      final list = data.map((e) => e.toEntity()).toList();
      yield list;
    } on Exception catch (_) {
      if (localData == null) {
        rethrow;
      }
    }
  }
}
