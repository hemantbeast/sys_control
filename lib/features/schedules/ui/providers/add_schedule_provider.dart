import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/enums/repeat_type_enum.dart';
import 'package:sys_control/features/schedules/domain/usecases/create_schedule_usecase.dart';
import 'package:sys_control/features/schedules/domain/usecases/update_schedule_usecase.dart';
import 'package:sys_control/features/schedules/ui/states/add_schedule_state.dart';

final addScheduleProvider = NotifierProvider.autoDispose<AddScheduleNotifier, AddScheduleState>(
  AddScheduleNotifier.new,
);

class AddScheduleNotifier extends Notifier<AddScheduleState> {
  @override
  AddScheduleState build() => AddScheduleState.initial();

  void loadForEdit(ScheduleEntity schedule) {
    state = AddScheduleState(
      name: schedule.name,
      mode: schedule.mode,
      startTime: schedule.startTime,
      timer: schedule.timer,
      repeatType: schedule.repeatType,
      repeatDays: schedule.repeatDays,
      isEditing: true,
      editingId: schedule.id,
    );
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setMode(ModeEnum mode) {
    state = state.copyWith(mode: mode);
  }

  void setStartTime(DateTime startTime) {
    state = state.copyWith(startTime: startTime);
  }

  void setTimer(int timer) {
    state = state.copyWith(timer: timer);
  }

  void setRepeatType(RepeatTypeEnum repeatType) {
    state = state.copyWith(repeatType: repeatType);
    if (repeatType != RepeatTypeEnum.weekly) {
      state = state.copyWith(repeatDays: []);
    }
  }

  void toggleRepeatDay(int dayIndex) {
    final days = List<int>.from(state.repeatDays);
    if (days.contains(dayIndex)) {
      days.remove(dayIndex);
    } else {
      days.add(dayIndex);
    }
    days.sort();
    state = state.copyWith(repeatDays: days);
  }

  bool validate() {
    if (state.name.trim().isEmpty) return false;
    if (state.startTime == null) return false;
    if (state.timer <= 0) return false;
    if (state.repeatType == RepeatTypeEnum.weekly && state.repeatDays.isEmpty) return false;
    return true;
  }

  Future<int?> save() async {
    if (!validate()) {
      state = state.copyWith(error: 'Please fill all required fields');
      return null;
    }

    final entity = ScheduleEntity(
      id: state.editingId ?? 0,
      name: state.name.trim(),
      mode: state.mode,
      startTime: state.startTime!,
      timer: state.timer,
      isEnabled: true,
      repeatType: state.repeatType,
      repeatDays: state.repeatDays,
    );

    if (state.isEditing) {
      final result = await ref.read(updateScheduleUseCaseProvider)(entity);
      return result.fold(
        (failure) {
          state = state.copyWith(error: failure.message);
          return null;
        },
        (_) => state.editingId,
      );
    }

    final result = await ref.read(createScheduleUseCaseProvider)(entity);
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return null;
      },
      (id) => id,
    );
  }
}
