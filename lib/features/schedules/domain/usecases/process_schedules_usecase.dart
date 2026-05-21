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

  String previewNextOccurrence(ScheduleEntity item, DateTime now) {
    final nextOccurrence = calculateNextOccurrence(item, now);
    if (nextOccurrence == null) return '';

    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextDate = DateTime(nextOccurrence.year, nextOccurrence.month, nextOccurrence.day);
    final timeStr = '${nextOccurrence.hour.toString().padLeft(2, '0')}:${nextOccurrence.minute.toString().padLeft(2, '0')}';

    if (nextDate == today) {
      return 'Today at $timeStr';
    } else if (nextDate == tomorrow) {
      return 'Tomorrow at $timeStr';
    } else {
      switch (item.repeatType) {
        case RepeatTypeEnum.daily:
          return 'Every day at $timeStr';
        case RepeatTypeEnum.weekly:
          if (item.repeatDays.isEmpty) return 'Weekly at $timeStr';
          const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          final selectedDays = item.repeatDays.map((idx) => dayLabels[idx]).join(', ');
          return 'Every $selectedDays at $timeStr';
        case RepeatTypeEnum.monthly:
          final day = nextDate.day;
          var suffix = 'th';
          if (day % 10 == 1 && day != 11) {
            suffix = 'st';
          } else if (day % 10 == 2 && day != 12) {
            suffix = 'nd';
          } else if (day % 10 == 3 && day != 13) {
            suffix = 'rd';
          }
          return 'Every $day$suffix of the month at $timeStr';
        case RepeatTypeEnum.once:
          final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          return '${months[nextDate.month - 1]} ${nextDate.day}, ${nextDate.year} at $timeStr';
      }
    }
  }
}
