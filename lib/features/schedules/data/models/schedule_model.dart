import 'package:json_annotation/json_annotation.dart';
import 'package:sys_control/core/utils/typedefs.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/enums/repeat_type_enum.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  const ScheduleModel({
    this.id,
    this.name,
    this.mode,
    this.startTime,
    this.timer,
    this.isEnabled,
    this.repeatType,
    this.repeatDays,
  });

  factory ScheduleModel.fromJson(JSON json) => _$ScheduleModelFromJson(json);

  factory ScheduleModel.fromEntity(ScheduleEntity entity) {
    return ScheduleModel(
      id: entity.id,
      name: entity.name,
      mode: entity.mode.name,
      startTime: entity.startTime.toIso8601String(),
      timer: entity.timer,
      isEnabled: entity.isEnabled,
      repeatType: entity.repeatType.index,
      repeatDays: entity.repeatDays.join(','),
    );
  }

  final int? id;
  final String? name;
  final String? mode;
  final String? startTime;
  final int? timer;
  final bool? isEnabled;
  final int? repeatType;
  final String? repeatDays;

  ScheduleEntity toEntity() {
    return ScheduleEntity(
      id: id ?? 0,
      name: name ?? '',
      mode: ModeEnum.values.firstWhere(
        (e) => e.name == (mode ?? 'heat'),
        orElse: () => ModeEnum.heat,
      ),
      startTime: startTime != null ? DateTime.parse(startTime!) : DateTime.now(),
      timer: timer ?? 0,
      isEnabled: isEnabled ?? false,
      repeatType: RepeatTypeEnum.values[repeatType ?? 0],
      repeatDays: (repeatDays ?? '').isNotEmpty
          ? repeatDays!.split(',').map((e) => int.parse(e.trim())).toList()
          : [],
    );
  }

  JSON toJson() => _$ScheduleModelToJson(this);
}
