import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/data/models/energy_model.dart';
import 'package:sys_control/features/dashboard/data/models/zone_model.dart';

final dashboardLocalProvider = Provider<DashboardLocal>((ref) {
  return DashboardLocal(ref: ref);
});

class DashboardLocal {
  DashboardLocal({required this.ref});

  final Ref ref;

  Future<void> saveEnergy(EnergyModel energy) async {
    // Save energy data to local db.
  }

  Future<EnergyModel?> getEnergy() async {
    // Get energy data from local db.
    return null;
  }

  Future<void> saveZones(List<ZoneModel> zones) async {
    // Save zone list to local db.
  }

  Future<List<ZoneModel>?> getZones() async {
    // Get zone data from local db.
    return null;
  }
}
