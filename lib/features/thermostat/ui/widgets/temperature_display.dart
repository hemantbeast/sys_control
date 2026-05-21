import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/themes/colors.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/settings/ui/providers/app_settings_provider.dart';
import 'package:sys_control/generated/l10n.dart';

const _minTemp = 15.0;
const _maxTemp = 35.0;
const _startAngle = 3 * math.pi / 4;
const _totalSweep = 3 * math.pi / 2;

class TemperatureDisplay extends ConsumerWidget {
  const TemperatureDisplay({
    required this.targetTemp,
    required this.indoorTemp,
    required this.mode,
    this.onTempChanged,
    this.size = 220,
    super.key,
  });

  final double targetTemp;

  final double indoorTemp;

  final ModeEnum mode;

  final ValueChanged<double>? onTempChanged;

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(appSettingsProvider).temperatureUnit;

    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onPanUpdate: onTempChanged == null
            ? null
            : (details) {
                final center = Offset(size / 2, size / 2);
                final progress = _progressFromCenter(center, details.localPosition);
                onTempChanged!(_minTemp + progress * (_maxTemp - _minTemp));
              },
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: (targetTemp - _minTemp) / (_maxTemp - _minTemp)),
          curve: Curves.easeOutCubic,
          duration: const Duration(milliseconds: 350),
          builder: (context, value, child) {
            return CustomPaint(
              painter: _ThermostatArcPainter(
                progress: value,
                activeColor: mode.color,
                trackColor: context.theme.colorScheme.surfaceContainerHighest,
              ),
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).target,
                style: const TextStyle(
                  color: slateGray,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              TweenAnimationBuilder<double>(
                tween: Tween(end: targetTemp),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                builder: (context, value, _) {
                  return Text(
                    unit.format(value),
                    style: TextStyle(
                      color: context.customTheme.blackTextStyle.color,
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                '${S.of(context).indoor} ${unit.format(indoorTemp)}',
                style: TextStyle(
                  color: mode.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double _progressFromCenter(Offset center, Offset touch) {
  final angle = math.atan2(touch.dy - center.dy, touch.dx - center.dx);
  var offset = (angle - _startAngle) % (2 * math.pi);
  if (offset < 0) offset += 2 * math.pi;
  // ponytail: dead zone is the gap at the bottom of the arc (offset > totalSweep).
  // Snap to nearest arc endpoint instead of jumping to max.
  if (offset > _totalSweep) {
    const deadZone = 2 * math.pi - _totalSweep;
    return (offset - _totalSweep) > deadZone / 2 ? 0.0 : 1.0;
  }
  return offset / _totalSweep;
}

class _ThermostatArcPainter extends CustomPainter {
  _ThermostatArcPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
  });

  final double progress;
  final Color activeColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 16;

    final currentSweepAngle = _totalSweep * progress.clamp(0.0, 1.0);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _startAngle,
      _totalSweep,
      false,
      trackPaint,
    );

    final glowPaint = Paint()
      ..color = activeColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _startAngle,
      currentSweepAngle,
      false,
      glowPaint,
    );

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _startAngle,
      currentSweepAngle,
      false,
      activePaint,
    );

    final thumbAngle = _startAngle + currentSweepAngle;
    final thumbCenter = Offset(
      center.dx + radius * math.cos(thumbAngle),
      center.dy + radius * math.sin(thumbAngle),
    );

    final thumbPaint = Paint()..color = Colors.white;
    canvas.drawCircle(thumbCenter, 10, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant _ThermostatArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor;
  }
}
