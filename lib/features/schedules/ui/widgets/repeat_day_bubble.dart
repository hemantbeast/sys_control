import 'package:flutter/material.dart';
import 'package:sys_control/core/extensions/context_extension.dart';

class RepeatDayBubble extends StatelessWidget {
  const RepeatDayBubble({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB77CFF) : context.theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFFB77CFF) : context.theme.dividerColor,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: context.customTheme.grayTextStyle.copyWith(
            color: isSelected ? Colors.white : null,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
