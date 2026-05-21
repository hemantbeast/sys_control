import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/routes/app_router.dart';
import 'package:sys_control/app/routes/route_enum.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/core/extensions/widget_extension.dart';
import 'package:sys_control/features/thermostat/ui/providers/thermostat_provider.dart';
import 'package:sys_control/features/thermostat/ui/widgets/mode_fan_chip.dart';
import 'package:sys_control/features/thermostat/ui/widgets/temperature_display.dart';
import 'package:sys_control/features/thermostat/ui/widgets/thermostat_background.dart';
import 'package:sys_control/generated/l10n.dart';

class ThermostatPage extends ConsumerWidget {
  const ThermostatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(thermostatProvider);
    final notifier = ref.read(thermostatProvider.notifier);

    return ThermostatBackground(
      mode: state.mode,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final arcSize = (constraints.maxHeight * 0.55).clamp(180.0, 300.0);

          return Column(
            children: [
              const Spacer(flex: 2),
              TemperatureDisplay(
                targetTemp: state.targetTemp,
                indoorTemp: state.indoorTemp,
                mode: state.mode,
                size: arcSize,
                onTempChanged: notifier.setTargetTemp,
              ),
              const SizedBox(height: 12),
              Text(
                '${S.of(context).humidity} ${state.humidity.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: context.customTheme.grayTextStyle.color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 24),
              ModeFanChip(
                mode: state.mode,
                fanSpeed: state.fanSpeed,
                onModeTap: () => AppRouter.pushNamed(RouteEnum.modeSelectionScreen.name),
                onFanTap: () => AppRouter.pushNamed(RouteEnum.fanSpeedSelectionScreen.name),
              ),
              const Spacer(flex: 3),
            ],
          );
        },
      ).applySafeArea(),
    );
  }
}
