import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/features/dashboard/data/sources/local/device_state_dao.dart';
import 'package:sys_control/features/dashboard/domain/entities/device_state_entity.dart';
import 'package:sys_control/features/dashboard/domain/repositories/device_state_repository.dart';

final deviceStateRepositoryProvider = Provider<DeviceStateRepository>((ref) {
  return DeviceStateRepositoryImpl(ref.watch(deviceStateDaoProvider));
});

final class DeviceStateRepositoryImpl extends DeviceStateRepository {
  const DeviceStateRepositoryImpl(this._dao);

  final DeviceStateDao _dao;

  @override
  Stream<List<DeviceStateEntity>> watchDevices() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<int> countDevices() {
    return _dao.count();
  }

  @override
  Future<void> upsertDevice(DeviceStateEntity device) {
    return _dao.upsert(
      DeviceStateTableCompanion(
        unitId: Value(device.unitId),
        unitType: Value(device.unitType),
        temperature: Value(device.temperature),
        humidity: Value(device.humidity),
        targetTemp: Value(device.targetTemp),
        mode: Value(device.mode),
        fanSpeed: Value(device.fanSpeed),
        isOn: Value(device.isOn),
        updatedAt: Value(device.updatedAt.toIso8601String()),
      ),
    );
  }

  @override
  Future<void> writeFields(
    String unitId,
    String unitType, {
    double? targetTemp,
    String? mode,
    String? fanSpeed,
    bool? isOn,
    double? temperature,
    double? humidity,
  }) {
    return _dao.upsert(
      DeviceStateTableCompanion(
        unitId: Value(unitId),
        unitType: Value(unitType),
        targetTemp: targetTemp == null ? const Value.absent() : Value(targetTemp),
        mode: mode == null ? const Value.absent() : Value(mode),
        fanSpeed: fanSpeed == null ? const Value.absent() : Value(fanSpeed),
        isOn: isOn == null ? const Value.absent() : Value(isOn),
        temperature: temperature == null ? const Value.absent() : Value(temperature),
        humidity: humidity == null ? const Value.absent() : Value(humidity),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  DeviceStateEntity _toEntity(DeviceStateRow row) {
    return DeviceStateEntity(
      unitId: row.unitId,
      unitType: row.unitType,
      temperature: row.temperature ?? 20,
      humidity: row.humidity ?? 50,
      targetTemp: row.targetTemp ?? 25,
      mode: row.mode ?? 'auto',
      fanSpeed: row.fanSpeed ?? 'auto',
      isOn: row.isOn ?? true,
      updatedAt: DateTime.tryParse(row.updatedAt) ?? DateTime.now(),
    );
  }
}
