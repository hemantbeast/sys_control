import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/usecases/process_schedules_usecase.dart';
import 'package:sys_control/features/schedules/domain/usecases/watch_schedules_usecase.dart';
import 'package:sys_control/features/schedules/ui/states/timer_state.dart';

final timerProvider = NotifierProvider.autoDispose<TimerNotifier, TimerState>(
  TimerNotifier.new,
);

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;
  List<ScheduleEntity> _schedules = [];
  bool _wasRunning = false;

  @override
  TimerState build() {
    final watchUseCase = ref.read(watchSchedulesUseCaseProvider);
    final sub = watchUseCase().listen((schedules) {
      _schedules = schedules;
    });
    ref.onDispose(() {
      sub.cancel();
      _timer?.cancel();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _processSchedules());

    return TimerState.initial();
  }

  void _processSchedules() {
    if (_schedules.isEmpty) return;

    final now = DateTime.now();
    final processUseCase = ref.read(processSchedulesUseCaseProvider);
    var scheduleRunning = false;

    var shortestRunningDuration = 999999999;
    var secondsRemaining = 0;
    var totalDuration = 1;
    var currentMode = ModeEnum.heat;
    int? activeId;
    var activeName = '';
    var upcomingName = '';
    var minimumTimeDifference = 999999999;

    for (final item in _schedules) {
      if (!item.isEnabled) continue;

      final effectiveStart = processUseCase.calculateNextOccurrence(item, now);
      if (effectiveStart == null) continue;

      final endTime = effectiveStart.add(Duration(seconds: item.timer));

      if (now.isAfter(effectiveStart) && now.isBefore(endTime)) {
        final currentTotalSeconds = item.timer;
        if (!scheduleRunning || currentTotalSeconds < shortestRunningDuration) {
          secondsRemaining = endTime.difference(now).inSeconds;
          totalDuration = currentTotalSeconds;
          currentMode = state.userModeOverride ?? item.mode;
          activeId = item.id;
          activeName = item.name;
          shortestRunningDuration = currentTotalSeconds;
          scheduleRunning = true;
        }
      } else if (effectiveStart.isAfter(now)) {
        final diff = effectiveStart.difference(now).inSeconds;
        if (diff < minimumTimeDifference) {
          minimumTimeDifference = diff;
          upcomingName = item.name;
        }
      }
    }

    if (_wasRunning && !scheduleRunning) {
      // Timer completed — could emit event here
    }

    if (!scheduleRunning) {
      state = state.copyWith(
        secondsRemaining: 0,
        totalDuration: 1,
        activeScheduleId: null,
        activeScheduleName: '',
        nextScheduleName: upcomingName,
        isRunning: false,
        userModeOverride: null,
      );
    } else {
      state = state.copyWith(
        secondsRemaining: secondsRemaining,
        totalDuration: totalDuration,
        currentMode: currentMode,
        activeScheduleId: activeId,
        activeScheduleName: activeName,
        nextScheduleName: upcomingName,
        isRunning: true,
      );
    }

    _wasRunning = scheduleRunning;
  }

  void stopTimer() {
    _timer?.cancel();
    state = TimerState.initial();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _processSchedules());
  }

  void setModeOverride(ModeEnum mode) {
    state = state.copyWith(userModeOverride: mode);
  }
}
