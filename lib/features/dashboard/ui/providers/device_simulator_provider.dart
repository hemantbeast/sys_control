import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/domain/usecases/update_device_state_usecase.dart';
import 'package:sys_control/features/dashboard/ui/providers/dashboard_provider.dart';

/// ponytail: debug simulator standing in for real IDU/ODU hardware.
/// Replace with a real device writer when hardware exists; delete this file.
final deviceSimulatorProvider = NotifierProvider<DeviceSimulatorNotifier, bool>(DeviceSimulatorNotifier.new);

class DeviceSimulatorNotifier extends Notifier<bool> {
  Timer? _timer;
  final math.Random _random = math.Random();
  double _iduTemp = 22;
  double _iduHumidity = 45;
  double _oduTemp = 32;

  @override
  bool build() {
    ref.onDispose(() => _timer?.cancel());
    return true;
  }

  void toggle() {
    if (state) {
      _timer?.cancel();
      _timer = null;
      state = false;
      return;
    }
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _tick());
    state = true;
  }

  void _tick() {
    final useCase = ref.read(updateDeviceStateUseCaseProvider);
    final dashboard = ref.read(dashboardProvider);

    _oduTemp = (_oduTemp + (_random.nextDouble() - 0.5) * 0.6).clamp(5.0, 50.0).toDouble();
    _iduTemp += (_random.nextDouble() - 0.5) * 0.4;
    if (dashboard.isOn) {
      _iduTemp += (dashboard.targetTemp - _iduTemp) * 0.2;
    }
    _iduTemp = _iduTemp.clamp(10.0, 45.0).toDouble();
    _iduHumidity = (_iduHumidity + (_random.nextDouble() - 0.5) * 2).clamp(20.0, 90.0).toDouble();

    useCase(kIduUnitId, 'IDU', temperature: _round(_iduTemp), humidity: _round(_iduHumidity));
    useCase(kOduUnitId, 'ODU', temperature: _round(_oduTemp));
  }

  double _round(double value) => double.parse(value.toStringAsFixed(1));
}
