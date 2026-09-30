class DeviceStateEntity {
  const DeviceStateEntity({
    required this.unitId,
    required this.unitType,
    required this.temperature,
    required this.humidity,
    required this.targetTemp,
    required this.mode,
    required this.fanSpeed,
    required this.isOn,
    required this.updatedAt,
  });

  final String unitId;
  final String unitType;
  final double temperature;
  final double humidity;
  final double targetTemp;
  final String mode;
  final String fanSpeed;
  final bool isOn;
  final DateTime updatedAt;
}
