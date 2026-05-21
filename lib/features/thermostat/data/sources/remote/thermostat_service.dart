import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/utils/json_utils.dart';
import 'package:sys_control/features/thermostat/data/mock/mock_data.dart';
import 'package:sys_control/features/thermostat/data/models/thermostat_model.dart';

final thermostatRemoteProvider = Provider<ThermostatService>((ref) {
  return ThermostatService(ref: ref);
});

class ThermostatService {
  ThermostatService({required this.ref});

  final Ref ref;

  Future<ThermostatModel> getThermostat() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    return JsonUtils.parseJson(thermostatMockData, ThermostatModel.fromJson);
  }

  Future<void> updateMode(int modeIndex) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  Future<void> updateFanSpeed(int fanSpeedIndex) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  Future<void> updateTargetTemp(double temp) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
