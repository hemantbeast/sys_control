import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/utils/json_utils.dart';
import 'package:sys_control/core/utils/typedefs.dart';
import 'package:sys_control/features/dashboard/data/mock/mock_data.dart';
import 'package:sys_control/features/dashboard/data/models/energy_model.dart';
import 'package:sys_control/features/dashboard/data/models/zone_model.dart';

final dashboardRemoteProvider = Provider<DashboardService>((ref) {
  return DashboardService(ref: ref);
});

class DashboardService {
  DashboardService({required this.ref});

  final Ref ref;

  Future<EnergyModel> getEnergy() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final data = JsonUtils.parseJson(energyMockData, EnergyModel.fromJson);
    return data;
  }

  Future<List<ZoneModel>> getZones() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final jsonList = json.decode(zonesMockData) as List<dynamic>;
    return jsonList.map((e) => ZoneModel.fromJson(e as JSON)).toList();
  }
}
