import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

class TimerStateEntity {
  const TimerStateEntity({
    required this.secondsRemaining,
    required this.totalDuration,
    required this.currentMode,
    required this.activeScheduleId,
    required this.activeScheduleName,
    required this.nextScheduleName,
  });

  final int secondsRemaining;
  final int totalDuration;
  final ModeEnum currentMode;
  final int? activeScheduleId;
  final String activeScheduleName;
  final String nextScheduleName;
}
