import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sys_control/app/themes/colors.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

class ModeFanChip extends StatelessWidget {
  const ModeFanChip({
    required this.mode,
    required this.fanSpeed,
    required this.onModeTap,
    required this.onFanTap,
    super.key,
  });

  final ModeEnum mode;

  final FanSpeedEnum fanSpeed;

  final VoidCallback onModeTap;

  final VoidCallback onFanTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [
        _Chip(
          label: mode.longName,
          color: mode.color,
          icon: Icons.thermostat_rounded,
          onTap: onModeTap,
        ),
        _Chip(
          label: fanSpeed.name.toUpperCase(),
          color: context.customTheme.grayTextStyle.color!,
          icon: Icons.air_rounded,
          onTap: onFanTap,
        ),
      ],
    ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String label;

  final Color color;

  final IconData icon;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 45),
        backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: context.theme.dividerColor),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(icon, size: 16, color: color),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 16, color: slateGray),
        ],
      ),
    );
  }
}
