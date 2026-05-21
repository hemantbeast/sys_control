import 'package:json_annotation/json_annotation.dart';
import 'package:sys_control/core/utils/typedefs.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

part 'zone_model.g.dart';

@JsonSerializable()
class ZoneModel {
  ZoneModel({
    this.name,
    this.isOn,
    this.isEco,
    this.temp,
    this.humidity,
    this.mode,
    this.fanSpeed,
  });

  factory ZoneModel.fromJson(JSON json) => _$ZoneModelFromJson(json);

  factory ZoneModel.fromEntity(ZoneEntity entity) {
    return ZoneModel(
      name: entity.name,
      isOn: entity.isOn,
      isEco: entity.isEco,
      temp: entity.temp,
      humidity: entity.humidity,
      fanSpeed: entity.fanSpeed.index,
      mode: entity.mode.index,
    );
  }

  JSON toJson() => _$ZoneModelToJson(this);

  ZoneEntity toEntity() {
    return ZoneEntity(
      name: name ?? '',
      fanSpeed: FanSpeedEnum.values[fanSpeed ?? 0],
      humidity: humidity ?? 0,
      isEco: isEco ?? false,
      isOn: isOn ?? false,
      mode: ModeEnum.values[mode ?? 0],
      temp: temp ?? 0,
    );
  }

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'is_on')
  bool? isOn;

  @JsonKey(name: 'is_eco')
  bool? isEco;

  @JsonKey(name: 'temp')
  double? temp;

  @JsonKey(name: 'humidity')
  double? humidity;

  @JsonKey(name: 'mode')
  int? mode;

  @JsonKey(name: 'fan_speed')
  int? fanSpeed;
}
