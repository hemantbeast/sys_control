import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/domain/entities/zone_entity.dart';
import 'package:sys_control/features/dashboard/ui/providers/dashboard_provider.dart';
import 'package:sys_control/features/dashboard/ui/widgets/fan_widget.dart';
import 'package:sys_control/features/dashboard/ui/widgets/thermostat_widget.dart';
import 'package:sys_control/features/dashboard/ui/widgets/top_schedule_widget.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return Column(
      spacing: 10,
      children: [
        Expanded(
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 45,
                child: ThermostatWidget(
                  notifier: notifier,
                  provider: provider,
                  avgHumidity: _avgHumidity(provider.zones),
                ),
              ),
              Expanded(
                flex: 55,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final scale = constraints.maxWidth / 540;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        spacing: 10 * scale,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FanWidget(provider: provider, energy: provider.energy, scale: scale),
                          SizedBox(
                            height: 300 * scale,
                            child: TopScheduleWidget(
                              schedules: provider.zones,
                              scale: scale,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _avgHumidity(List<ZoneEntity> zones) {
    if (zones.isEmpty) return 0;
    return zones.map((z) => z.humidity).reduce((a, b) => a + b) / zones.length;
  }
}
