import 'package:json_annotation/json_annotation.dart';
import 'package:sys_control/core/utils/typedefs.dart';
import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';

part 'energy_model.g.dart';

@JsonSerializable()
class EnergyModel {
  EnergyModel({
    this.cost,
    this.usage,
    this.efficiency,
    this.outdoorTemp,
  });

  factory EnergyModel.fromJson(JSON json) => _$EnergyModelFromJson(json);

  factory EnergyModel.fromEntity(EnergyEntity entity) {
    return EnergyModel(
      cost: entity.cost,
      efficiency: entity.efficiency,
      usage: entity.usage,
      outdoorTemp: entity.outdoorTemp,
    );
  }

  JSON toJson() => _$EnergyModelToJson(this);

  EnergyEntity toEntity() {
    return EnergyEntity(
      cost: cost ?? 0,
      efficiency: efficiency ?? 0,
      usage: usage ?? 0,
      outdoorTemp: outdoorTemp ?? 0,
    );
  }

  @JsonKey(name: 'cost')
  double? cost;

  @JsonKey(name: 'efficiency')
  double? efficiency;

  @JsonKey(name: 'usage')
  double? usage;

  @JsonKey(name: 'outdoor_temp')
  double? outdoorTemp;
}
