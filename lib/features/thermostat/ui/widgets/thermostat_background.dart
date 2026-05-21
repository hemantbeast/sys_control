import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

class ThermostatBackground extends StatelessWidget {
  const ThermostatBackground({
    required this.mode,
    required this.child,
    super.key,
  });

  final ModeEnum mode;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.3),
          radius: 1.2,
          colors: [
            mode.color.withValues(alpha: 0.15),
            mode.color.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: child,
    ).animate().fadeIn(duration: 400.ms);
  }
}
