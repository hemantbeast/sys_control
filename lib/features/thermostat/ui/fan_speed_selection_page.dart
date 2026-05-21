import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/routes/app_router.dart';
import 'package:sys_control/app/themes/colors.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/core/extensions/widget_extension.dart';
import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/thermostat/ui/providers/thermostat_provider.dart';

class FanSpeedSelectionPage extends ConsumerWidget {
  const FanSpeedSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFanSpeed = ref.watch(thermostatProvider).fanSpeed;
    final modeColor = ref.watch(thermostatProvider).mode.color;
    final notifier = ref.read(thermostatProvider.notifier);

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: AppRouter.pop,
        ),
        title: const Text('Fan Speed'),
        centerTitle: true,
      ),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: FanSpeedEnum.values.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final fanSpeed = FanSpeedEnum.values[index];
            final isActive = fanSpeed == currentFanSpeed;

            return _FanSpeedCard(
              fanSpeed: fanSpeed,
              isActive: isActive,
              modeColor: modeColor,
              barCount: index,
              onTap: () {
                notifier.setFanSpeed(fanSpeed);
                AppRouter.pop();
              },
            ).animate().fadeIn(delay: (index * 60).ms).scale(begin: const Offset(0.9, 0.9), duration: 300.ms, curve: Curves.easeOut);
          },
        ),
      ),
    );
  }
}

class _FanSpeedCard extends StatelessWidget {
  const _FanSpeedCard({
    required this.fanSpeed,
    required this.isActive,
    required this.modeColor,
    required this.barCount,
    required this.onTap,
  });

  final FanSpeedEnum fanSpeed;
  final bool isActive;
  final Color modeColor;
  final int barCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? modeColor.withValues(alpha: 0.08) : context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? modeColor : context.theme.colorScheme.surfaceContainerHighest,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: modeColor.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: modeColor.withValues(alpha: 0.12),
            ),
            child: Icon(
              _iconForSpeed(fanSpeed),
              color: isActive ? modeColor : slateGray,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fanSpeed.name[0].toUpperCase() + fanSpeed.name.substring(1),
            style: TextStyle(
              color: isActive ? modeColor : context.customTheme.blackTextStyle.color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final isBarActive = i < barCount || fanSpeed == FanSpeedEnum.auto;

              return Container(
                width: 16,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: isBarActive ? modeColor : context.theme.colorScheme.surfaceContainerHighest,
                ),
              );
            }),
          ),
        ],
      ),
    ).onTap(
      context: context,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
    );
  }

  IconData _iconForSpeed(FanSpeedEnum fanSpeed) {
    return switch (fanSpeed) {
      FanSpeedEnum.auto => Icons.autorenew_rounded,
      FanSpeedEnum.low => Icons.air_rounded,
      FanSpeedEnum.med => Icons.wind_power_rounded,
      FanSpeedEnum.high => Icons.storm_rounded,
    };
  }
}
