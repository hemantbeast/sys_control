import 'package:json_annotation/json_annotation.dart';
import 'package:sys_control/core/utils/typedefs.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/thermostat/domain/entities/thermostat_entity.dart';

part 'thermostat_model.g.dart';

@JsonSerializable()
class ThermostatModel {
  ThermostatModel({
    this.targetTemp,
    this.indoorTemp,
    this.humidity,
    this.mode,
    this.fanSpeed,
    this.isOn,
  });

  factory ThermostatModel.fromJson(JSON json) => _$ThermostatModelFromJson(json);

  factory ThermostatModel.fromEntity(ThermostatEntity entity) {
    return ThermostatModel(
      targetTemp: entity.targetTemp,
      indoorTemp: entity.indoorTemp,
      humidity: entity.humidity,
      mode: entity.mode.index,
      fanSpeed: entity.fanSpeed.index,
      isOn: entity.isOn,
    );
  }

  JSON toJson() => _$ThermostatModelToJson(this);

  ThermostatEntity toEntity() {
    return ThermostatEntity(
      targetTemp: targetTemp ?? 24,
      indoorTemp: indoorTemp ?? 22,
      humidity: humidity ?? 50,
      mode: ModeEnum.values[mode ?? 0],
      fanSpeed: FanSpeedEnum.values[fanSpeed ?? 0],
      isOn: isOn ?? false,
    );
  }

  @JsonKey(name: 'target_temp')
  double? targetTemp;

  @JsonKey(name: 'indoor_temp')
  double? indoorTemp;

  @JsonKey(name: 'humidity')
  double? humidity;

  @JsonKey(name: 'mode')
  int? mode;

  @JsonKey(name: 'fan_speed')
  int? fanSpeed;

  @JsonKey(name: 'is_on')
  bool? isOn;
}
