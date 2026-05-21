import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/schedules/domain/usecases/delete_schedule_usecase.dart';
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
      (schedules) {
        state = state.copyWith(schedules: schedules, isLoading: false);
      },
      onError: (Object error) {
        state = state.copyWith(error: error.toString(), isLoading: false);
      },
    );
    ref.onDispose(sub.cancel);
    return ScheduleListState.initial();
  }

  Future<void> deleteSchedule(int id) async {
    final deleteUseCase = ref.read(deleteScheduleUseCaseProvider);
    await deleteUseCase.delete(id);
  }

  Future<void> toggleEnabled(int id, {required bool isEnabled}) async {
    final deleteUseCase = ref.read(deleteScheduleUseCaseProvider);
    await deleteUseCase.toggleEnabled(id, isEnabled: isEnabled);
  }
}
