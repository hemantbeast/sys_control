import 'package:flutter/material.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/schedules/domain/enums/repeat_type_enum.dart';

class ScheduleListItem extends StatelessWidget {
  const ScheduleListItem({
    required this.name,
    required this.mode,
    required this.startTime,
    required this.timer,
    required this.isEnabled,
    required this.repeatType,
    required this.isRunning,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final String name;
  final ModeEnum mode;
  final DateTime startTime;
  final int timer;
  final bool isEnabled;
  final RepeatTypeEnum repeatType;
  final bool isRunning;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: isRunning ? mode.color.withValues(alpha: 0.15) : context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isRunning ? Border.all(color: mode.color.withValues(alpha: 0.4), width: 2) : null,
        boxShadow: context.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: mode.color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            children: [
              Icon(_modeIcon(mode), color: mode.color, size: 24),
              if (repeatType != RepeatTypeEnum.once)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB77CFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.repeat, size: 8, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: context.customTheme.blackTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isRunning) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: mode.color.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'RUNNING',
                          style: TextStyle(
                            color: mode.color,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.play_arrow, size: 13, color: context.customTheme.grayTextStyle.color),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimeInfo(startTime, repeatType),
                      style: context.customTheme.grayTextStyle.copyWith(fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.access_time, size: 13, color: context.customTheme.grayTextStyle.color),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(timer),
                      style: context.customTheme.grayTextStyle.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeThumbColor: const Color(0xFF4CAF50),
            activeTrackColor: const Color(0xFF4CAF50).withValues(alpha: 0.8),
            inactiveThumbColor: context.customTheme.grayTextStyle.color,
            inactiveTrackColor: context.theme.dividerColor,
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 22, color: context.customTheme.grayTextStyle.color),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 25, color: Color(0xFFEF5350)),
            onPressed: onDelete,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  static IconData _modeIcon(ModeEnum mode) {
    return switch (mode) {
      ModeEnum.auto => Icons.autorenew,
      ModeEnum.heat => Icons.whatshot,
      ModeEnum.cool => Icons.ac_unit,
      ModeEnum.dry => Icons.water_drop_outlined,
      ModeEnum.fan => Icons.air,
    };
  }

  static String _formatTimeInfo(DateTime startTime, RepeatTypeEnum repeatType) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final timeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

    return switch (repeatType) {
      RepeatTypeEnum.once => '${months[startTime.month - 1]} ${startTime.day}, ${startTime.year}  $timeStr',
      RepeatTypeEnum.daily => 'Every day  $timeStr',
      RepeatTypeEnum.weekly => 'Weekly  $timeStr',
      RepeatTypeEnum.monthly => 'Every month  $timeStr',
    };
  }

  static String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (m > 0 && s > 0) return '${m}m ${s}s';
    if (m > 0) return '${m}m';
    return '${s}s';
  }
}
