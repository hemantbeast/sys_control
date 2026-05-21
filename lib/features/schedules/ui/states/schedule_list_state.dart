import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';

part 'schedule_list_state.freezed.dart';

@freezed
abstract class ScheduleListState with _$ScheduleListState {
  const factory ScheduleListState({
    required List<ScheduleEntity> schedules,
    required bool isLoading,
    String? error,
  }) = _ScheduleListState;

  factory ScheduleListState.initial() => const ScheduleListState(
        schedules: [],
        isLoading: true,
      );
}
