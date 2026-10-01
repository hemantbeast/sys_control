import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/themes/colors.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/core/extensions/widget_extension.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/dashboard/ui/painters/thermostat_painter.dart';
import 'package:sys_control/features/dashboard/ui/providers/dashboard_provider.dart';
import 'package:sys_control/features/dashboard/ui/states/dashboard_state.dart';
import 'package:sys_control/features/settings/ui/providers/app_settings_provider.dart';
import 'package:sys_control/generated/l10n.dart';

class ThermostatWidget extends ConsumerStatefulWidget {
  const ThermostatWidget({
    required this.notifier,
    required this.provider,
    this.avgHumidity = 0,
    super.key,
  });

  final DashboardState provider;

  final DashboardNotifier notifier;

  final double avgHumidity;

  @override
  ConsumerState<ThermostatWidget> createState() => _ThermostatWidgetState();
}

class _ThermostatWidgetState extends ConsumerState<ThermostatWidget> {
  late double _initialProgress;

  @override
  void initState() {
    super.initState();
    _initialProgress = _progressForTemp(widget.provider.targetTemp);
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final notifier = widget.notifier;
    final avgHumidity = widget.avgHumidity;
    final unit = ref.watch(appSettingsProvider).temperatureUnit;

    return LayoutBuilder(
      builder: (context, constraints) {
        // ponytail: scale the thermostat content relative to its 360px design width.
        final scale = constraints.maxWidth / 360;

        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: context.theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
            boxShadow: context.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                spacing: 10 * scale,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(ModeEnum.values.length, (index) {
                  return _ModeButton(
                    mode: ModeEnum.values[index],
                    isActive: provider.currentMode == ModeEnum.values[index],
                    notifier: notifier,
                    scale: scale,
                  );
                }),
              ),
              SizedBox(height: 20 * scale),
              SizedBox(
                width: 200 * scale,
                height: 200 * scale,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final size = 200 * scale;
                    final center = Offset(size / 2, size / 2);
                    final progress = _progressFromCenter(center, details.localPosition);
                    notifier.setTargetTemp(15 + progress * 20);
                  },
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      // Calculate percentage based on a standard temp range (15°C - 35°C)
                      begin: _initialProgress,
                      end: _progressForTemp(provider.targetTemp),
                    ),
                    curve: Curves.easeOutCubic,
                    duration: const Duration(milliseconds: 450),
                    builder: (context, value, child) {
                      return CustomPaint(
                        painter: ThermostatPainter(
                          progress: value,
                          activeColor: provider.currentMode.color,
                          trackColor: context.theme.colorScheme.surfaceContainerHighest,
                        ),
                        child: child,
                      );
                    },
                    child: Column(
                      spacing: 4 * scale,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).target,
                          style: TextStyle(
                            color: slateGray,
                            fontSize: 10 * scale,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          unit.format(provider.targetTemp),
                          style: TextStyle(
                            color: context.customTheme.blackTextStyle.color,
                            fontSize: 50 * scale,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${S.of(context).indoor} ${unit.format(provider.indoorTemp)}',
                          style: TextStyle(
                            color: provider.currentMode.color,
                            fontSize: 12 * scale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Minus Button
                  _buildRoundButton(
                    icon: Icons.remove,
                    onPressed: notifier.decreaseTemp,
                    scale: scale,
                    context: context,
                  ),
                  // Center Power Button
                  Container(
                    width: 68 * scale,
                    height: 68 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: provider.currentMode.color, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: provider.currentMode.color.withValues(alpha: 0.15),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.power_settings_new_rounded, size: 30 * scale),
                      color: provider.currentMode.color,
                      onPressed: () {},
                    ),
                  ),
                  // Plus Button
                  _buildRoundButton(
                    icon: Icons.add,
                    onPressed: notifier.increaseTemp,
                    scale: scale,
                    context: context,
                  ),
                ],
              ),
              SizedBox(height: 16 * scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InfoChip(
                    icon: Icons.arrow_downward_rounded,
                    label: unit.format(provider.energy.outdoorTemp),
                    subtitle: S.of(context).outdoor,
                    scale: scale,
                  ),
                  _InfoChip(
                    icon: Icons.water_drop_outlined,
                    label: '${avgHumidity.toStringAsFixed(0)}%',
                    subtitle: S.of(context).humidity,
                    scale: scale,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoundButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double scale,
    required BuildContext context,
  }) {
    return Container(
      width: 44 * scale,
      height: 44 * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.theme.colorScheme.surfaceContainerHighest,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20 * scale),
        color: context.customTheme.grayTextStyle.color,
        onPressed: onPressed,
      ),
    );
  }

  double _progressForTemp(double temp) {
    return math.max(0, math.min(1, (temp - 15) / (35 - 15))).toDouble();
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.mode,
    required this.isActive,
    required this.notifier,
    required this.scale,
  });

  final ModeEnum mode;

  final bool isActive;

  final DashboardNotifier notifier;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 6 * scale),
      decoration: BoxDecoration(
        color: isActive ? Colors.transparent : context.theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(15 * scale),
        border: Border.all(
          color: isActive ? mode.color : context.theme.dividerColor,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive) ...[
            Container(
              width: 4 * scale,
              height: 4 * scale,
              decoration: BoxDecoration(
                color: mode.color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 5 * scale),
          ],
          Text(
            mode.name.toUpperCase(),
            style: TextStyle(
              color: isActive ? mode.color : context.customTheme.lightGrayTextStyle.color,
              fontSize: 10 * scale,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    ).onTap(
      context: context,
      borderRadius: BorderRadius.circular(15 * scale),
      onTap: () {
        notifier.setCurrentMode(mode);
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.scale,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * scale, vertical: 8 * scale),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      child: Row(
        spacing: 8 * scale,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16 * scale, color: context.customTheme.grayTextStyle.color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: context.customTheme.blackTextStyle.copyWith(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: context.customTheme.grayTextStyle.copyWith(fontSize: 10 * scale),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

double _progressFromCenter(Offset center, Offset touch) {
  const startAngle = 3 * math.pi / 4;
  const totalSweep = 3 * math.pi / 2;
  final angle = math.atan2(touch.dy - center.dy, touch.dx - center.dx);
  var offset = (angle - startAngle) % (2 * math.pi);

  if (offset < 0) offset += 2 * math.pi;
  // ponytail: dead zone is the gap at the bottom of the arc (offset > totalSweep).
  // Snap to nearest arc endpoint instead of jumping to max.

  if (offset > totalSweep) {
    const deadZone = 2 * math.pi - totalSweep;
    return (offset - totalSweep) > deadZone / 2 ? 0.0 : 1.0;
  }
  return offset / totalSweep;
}
