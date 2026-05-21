import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/schedules/domain/enums/repeat_type_enum.dart';

part 'add_schedule_state.freezed.dart';

@freezed
abstract class AddScheduleState with _$AddScheduleState {
  const factory AddScheduleState({
    required String name,
    required ModeEnum mode,
    required DateTime? startTime,
    required int timer,
    required RepeatTypeEnum repeatType,
    required List<int> repeatDays,
    required bool isEditing,
    int? editingId,
    String? error,
  }) = _AddScheduleState;

  factory AddScheduleState.initial() => const AddScheduleState(
        name: '',
        mode: ModeEnum.heat,
        startTime: null,
        timer: 0,
        repeatType: RepeatTypeEnum.once,
        repeatDays: [],
        isEditing: false,
      );
}
