import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/dashboard/ui/providers/dashboard_provider.dart';
import 'package:sys_control/features/thermostat/ui/states/thermostat_state.dart';

final thermostatProvider = NotifierProvider.autoDispose<ThermostatNotifier, ThermostatState>(ThermostatNotifier.new);

class ThermostatNotifier extends Notifier<ThermostatState> {
  @override
  ThermostatState build() {
    final dashboard = ref.watch(dashboardProvider);

    return ThermostatState(
      targetTemp: dashboard.targetTemp,
      indoorTemp: dashboard.indoorTemp,
      humidity: dashboard.zones.isNotEmpty ? dashboard.zones[0].humidity : 50,
      mode: dashboard.currentMode,
      fanSpeed: dashboard.fanSpeed,
      isOn: dashboard.isOn,
    );
  }

  void increaseTemp() {
    ref.read(dashboardProvider.notifier).increaseTemp();
  }

  void decreaseTemp() {
    ref.read(dashboardProvider.notifier).decreaseTemp();
  }

  void setTargetTemp(double temp) {
    ref.read(dashboardProvider.notifier).setTargetTemp(temp);
  }

  void setMode(ModeEnum mode) {
    ref.read(dashboardProvider.notifier).setCurrentMode(mode);
  }

  void setFanSpeed(FanSpeedEnum fanSpeed) {
    ref.read(dashboardProvider.notifier).setFanSpeed(fanSpeed);
  }

  void togglePower() {
    ref.read(dashboardProvider.notifier).togglePower();
  }
}
