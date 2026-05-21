import 'package:flutter/material.dart';
import 'package:sys_control/core/extensions/context_extension.dart';

class TimerPresetChip extends StatelessWidget {
  const TimerPresetChip({
    required this.label,
    required this.seconds,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final int seconds;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD166) : context.theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD166) : context.theme.dividerColor,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: context.customTheme.grayTextStyle.copyWith(
            color: isSelected ? Colors.black : null,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
