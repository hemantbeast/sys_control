import 'package:sys_control/features/dashboard/domain/entities/device_state_entity.dart';

abstract class DeviceStateRepository {
  const DeviceStateRepository();

  Stream<List<DeviceStateEntity>> watchDevices();
  Future<void> upsertDevice(DeviceStateEntity device);
  Future<void> writeFields(
    String unitId,
    String unitType, {
    double? targetTemp,
    String? mode,
    String? fanSpeed,
    bool? isOn,
    double? temperature,
    double? humidity,
  });
}
