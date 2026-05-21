import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

part 'timer_state.freezed.dart';

@freezed
abstract class TimerState with _$TimerState {
  const factory TimerState({
    required int secondsRemaining,
    required int totalDuration,
    required ModeEnum currentMode,
    required String activeScheduleName,
    required String nextScheduleName,
    required bool isRunning,
    int? activeScheduleId,
    ModeEnum? userModeOverride,
  }) = _TimerState;

  factory TimerState.initial() => const TimerState(
        secondsRemaining: 0,
        totalDuration: 1,
        currentMode: ModeEnum.heat,
        activeScheduleName: '',
        nextScheduleName: '',
        isRunning: false,
      );
}
