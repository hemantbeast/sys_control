import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/themes/colors.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/dashboard/domain/entities/energy_entity.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/ui/painters/fan_painter.dart';
import 'package:sys_control/features/dashboard/ui/states/dashboard_state.dart';
import 'package:sys_control/features/settings/ui/providers/app_settings_provider.dart';
import 'package:sys_control/generated/l10n.dart';

class FanWidget extends ConsumerStatefulWidget {
  const FanWidget({
    required this.provider,
    required this.energy,
    this.aqiValue = 12,
    this.scale = 1,
    super.key,
  });

  final int aqiValue;
  final DashboardState provider;
  final EnergyEntity energy;
  final double scale;

  @override
  ConsumerState<FanWidget> createState() => _FanWidgetState();
}

class _FanWidgetState extends ConsumerState<FanWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _rotationDuration(widget.provider.fanSpeed),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant FanWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.provider.fanSpeed != widget.provider.fanSpeed) {
      _controller.duration = _rotationDuration(widget.provider.fanSpeed);
      _controller
        ..stop()
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration _rotationDuration(FanSpeedEnum speed) => switch (speed) {
    FanSpeedEnum.auto => const Duration(seconds: 3),
    FanSpeedEnum.low => const Duration(seconds: 4),
    FanSpeedEnum.med => const Duration(seconds: 2),
    FanSpeedEnum.high => const Duration(milliseconds: 1000),
  };

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final provider = widget.provider;
    final energy = widget.energy;
    final settings = ref.watch(appSettingsProvider);
    final l10n = S.of(context);

    return Container(
      padding: EdgeInsets.all(15 * scale),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(15 * scale),
        border: Border.all(
          color: context.theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
        boxShadow: context.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 35,
            child: Column(
              spacing: 13 * scale,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.fanSpeed,
                  style: TextStyle(
                    color: slateGray,
                    fontSize: 11 * scale,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(
                  width: 70 * scale,
                  height: 70 * scale,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * 3.14159,
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: Size(70 * scale, 70 * scale),
                      painter: FanPainter(
                        activeColor: provider.currentMode.color,
                        trackColor: context.theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                ),
                Text(
                  provider.fanSpeed.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: context.customTheme.grayTextStyle.copyWith(
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 65,
            child: Column(
              spacing: 10 * scale,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10 * scale,
                  children: [
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.bolt_rounded,
                        iconColor: const Color(0xFFFFD000),
                        value: '${energy.usage.toStringAsFixed(1)} kWh',
                        label: l10n.energy,
                        scale: scale,
                      ),
                    ),
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.air,
                        iconColor: const Color(0xFF3B82F6),
                        value: '${widget.aqiValue} AQI',
                        valueColor: context.theme.colorScheme.tertiary,
                        label: l10n.airQuality,
                        scale: scale,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 10 * scale,
                  children: [
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.attach_money_rounded,
                        iconColor: const Color(0xFFFFD000),
                        value: '${settings.currency.symbol}${energy.cost.toStringAsFixed(2)}',
                        label: l10n.cost,
                        scale: scale,
                      ),
                    ),
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.eco_rounded,
                        iconColor: const Color(0xFF4ADE80),
                        value: '${energy.efficiency.toStringAsFixed(0)}%',
                        label: l10n.efficiency,
                        scale: scale,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.scale,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final Color? valueColor;
  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 15 * scale),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Icon(icon, size: 24 * scale, color: iconColor),
          Column(
            spacing: 3 * scale,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                value,
                style: context.customTheme.blackTextStyle.copyWith(
                  fontSize: 15 * scale,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                label,
                style: context.customTheme.grayTextStyle.copyWith(fontSize: 11 * scale),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
