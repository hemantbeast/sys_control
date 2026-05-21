import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/schedules/domain/enums/repeat_type_enum.dart';

class ScheduleEntity {
  const ScheduleEntity({
    required this.id,
    required this.name,
    required this.mode,
    required this.startTime,
    required this.timer,
    required this.isEnabled,
    required this.repeatType,
    required this.repeatDays,
  });

  final int id;
  final String name;
  final ModeEnum mode;
  final DateTime startTime;
  final int timer;
  final bool isEnabled;
  final RepeatTypeEnum repeatType;
  final List<int> repeatDays;
}
