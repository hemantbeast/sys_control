import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/thermostat/data/models/thermostat_model.dart';

final thermostatLocalProvider = Provider<ThermostatLocal>((ref) {
  return ThermostatLocal(ref: ref);
});

class ThermostatLocal {
  ThermostatLocal({required this.ref});

  final Ref ref;

  ThermostatModel? _cached;

  Future<void> save(ThermostatModel model) async {
    _cached = model;
  }

  Future<ThermostatModel?> get() async {
    return _cached;
  }
}
