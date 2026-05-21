import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';

abstract class DashboardRepository {
  Stream<EnergyEntity> watchEnergy();

  Stream<List<ZoneEntity>> watchZones();
}
