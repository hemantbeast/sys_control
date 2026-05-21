import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/settings/ui/providers/app_settings_provider.dart';

class TopScheduleWidget extends ConsumerWidget {
  const TopScheduleWidget({
    required this.schedules,
    this.scale = 1,
    super.key,
  });

  final List<ZoneEntity> schedules;

  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(appSettingsProvider).temperatureUnit;

    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisCount = 2;
        const mainAxisSpacing = 10.0;
        const crossAxisSpacing = 10.0;
        final availableWidth = constraints.maxWidth - (crossAxisCount - 1) * crossAxisSpacing;
        final cellWidth = availableWidth / crossAxisCount;
        final availableHeight = constraints.maxHeight - ((schedules.length / crossAxisCount).ceil() - 1) * mainAxisSpacing;
        final cellHeight = availableHeight / (schedules.length / crossAxisCount).ceil().clamp(1, 999);
        final childAspectRatio = (cellWidth / cellHeight).clamp(0.01, 10.0);

        return GridView.builder(
          itemCount: schedules.length,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing * scale,
            crossAxisSpacing: crossAxisSpacing * scale,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final zone = schedules[index];
            final activeIndicatorColor = zone.isOn ? const Color(0xff2ecc71) : context.customTheme.lightGrayTextStyle.color;

            return Container(
              padding: EdgeInsets.all(10 * scale),
              decoration: BoxDecoration(
                color: zone.isOn ? context.theme.cardColor : context.theme.cardColor.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8 * scale),
                border: zone.isOn
                    ? Border(
                        left: BorderSide(
                          color: zone.mode.color,
                          width: 4 * scale,
                        ),
                      )
                    : Border.all(
                        color: context.theme.colorScheme.outline.withValues(alpha: 0.5),
                      ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 2 * scale,
                    right: 2 * scale,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: activeIndicatorColor,
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                      child: SizedBox(
                        height: 8 * scale,
                        width: 8 * scale,
                      ),
                    ),
                  ),
                  Column(
                    spacing: 2 * scale,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        spacing: 6 * scale,
                        children: [
                          Icon(
                            _modeIcon(zone.mode),
                            size: 15 * scale,
                            color: zone.mode.color,
                          ),
                          Text(
                            zone.name,
                            style: context.customTheme.grayTextStyle.copyWith(
                              color: zone.mode.color,
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 4 * scale,
                        children: [
                          Icon(
                            Icons.water_drop_outlined,
                            size: 14 * scale,
                            color: context.customTheme.lightGrayTextStyle.color,
                          ),
                          Text(
                            '${zone.humidity.toStringAsFixed(0)}%',
                            style: context.customTheme.grayTextStyle.copyWith(
                              fontSize: 14 * scale,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 2 * scale,
                    right: 2 * scale,
                    child: Text(
                      unit.format(zone.temp, decimals: 1),
                      style: context.customTheme.blackTextStyle.copyWith(
                        fontSize: 20 * scale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  IconData _modeIcon(ModeEnum mode) => switch (mode) {
    ModeEnum.auto => Icons.sync_rounded,
    ModeEnum.heat => Icons.whatshot_rounded,
    ModeEnum.cool => Icons.ac_unit_rounded,
    ModeEnum.dry => Icons.water_outlined,
    ModeEnum.fan => Icons.air_rounded,
  };
}
