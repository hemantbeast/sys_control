import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/schedules/domain/usecases/delete_schedule_usecase.dart';
import 'package:sys_control/features/schedules/domain/usecases/toggle_schedule_enabled_usecase.dart';
import 'package:sys_control/features/schedules/domain/usecases/watch_schedules_usecase.dart';
import 'package:sys_control/features/schedules/ui/states/schedule_list_state.dart';

final scheduleListProvider = NotifierProvider.autoDispose<ScheduleListNotifier, ScheduleListState>(
  ScheduleListNotifier.new,
);

class ScheduleListNotifier extends Notifier<ScheduleListState> {
  @override
  ScheduleListState build() {
    final watchUseCase = ref.read(watchSchedulesUseCaseProvider);
    final sub = watchUseCase().listen(
      (result) {
        result.fold(
          (failure) {
            state = state.copyWith(error: failure.message, isLoading: false);
          },
          (schedules) {
            state = state.copyWith(schedules: schedules, isLoading: false);
          },
        );
      },
    );
    ref.onDispose(sub.cancel);
    return ScheduleListState.initial();
  }

  Future<void> deleteSchedule(int id) async {
    final result = await ref.read(deleteScheduleUseCaseProvider)(id);
    result.fold(
      (failure) => debugPrint('Failed to delete schedule: $failure'),
      (_) {},
    );
  }

  Future<void> toggleEnabled(int id, {required bool isEnabled}) async {
    final result = await ref.read(toggleScheduleEnabledUseCaseProvider)(id, isEnabled: isEnabled);
    result.fold(
      (failure) => debugPrint('Failed to toggle schedule: $failure'),
      (_) {},
    );
  }
}
