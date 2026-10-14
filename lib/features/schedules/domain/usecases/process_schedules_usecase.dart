import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/enums/repeat_type_enum.dart';

final processSchedulesUseCaseProvider = Provider<ProcessSchedulesUseCase>((ref) {
  return const ProcessSchedulesUseCase();
});

class ProcessSchedulesUseCase {
  const ProcessSchedulesUseCase();

  DateTime? calculateNextOccurrence(ScheduleEntity item, DateTime now) {
    final timeOfDay = item.startTime;
    final baseDate = now;
    var target = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
      timeOfDay.second,
    );

    switch (item.repeatType) {
      case RepeatTypeEnum.once:
        return item.startTime;

      case RepeatTypeEnum.daily:
        if (target.add(Duration(seconds: item.timer)).isBefore(now)) {
          target = target.add(const Duration(days: 1));
        }
        return target;

      case RepeatTypeEnum.weekly:
        if (item.repeatDays.isEmpty) return null;
        DateTime? closestMatch;
        var minSecs = double.maxFinite.toInt();
        for (var daysAhead = 0; daysAhead < 7; daysAhead++) {
          final candidate = target.add(Duration(days: daysAhead));
          final candidateDayIdx = candidate.weekday - 1;
          if (item.repeatDays.contains(candidateDayIdx)) {
            var adjusted = candidate;
            if (daysAhead == 0 && candidate.add(Duration(seconds: item.timer)).isBefore(now)) {
              adjusted = candidate.add(const Duration(days: 7));
            }
            final diff = now.difference(adjusted).inSeconds.abs();
            if (diff < minSecs) {
              minSecs = diff;
              closestMatch = adjusted;
            }
          }
        }
        return closestMatch;

      case RepeatTypeEnum.monthly:
        target = DateTime(
          now.year,
          now.month,
          item.startTime.day,
          timeOfDay.hour,
          timeOfDay.minute,
          timeOfDay.second,
        );
        if (target.add(Duration(seconds: item.timer)).isBefore(now)) {
          target = DateTime(
            now.year,
            now.month + 1,
            item.startTime.day,
            timeOfDay.hour,
            timeOfDay.minute,
            timeOfDay.second,
          );
        }
        return target;
    }
  }
}
