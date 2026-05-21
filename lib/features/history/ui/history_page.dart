import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/core/extensions/widget_extension.dart';
import 'package:sys_control/features/history/ui/enums/history_time_range.dart';
import 'package:sys_control/features/history/ui/providers/history_provider.dart';
import 'package:sys_control/features/history/ui/widgets/energy_cost_chart_card.dart';
import 'package:sys_control/features/history/ui/widgets/energy_usage_chart_card.dart';
import 'package:sys_control/features/history/ui/widgets/humidity_chart_card.dart';
import 'package:sys_control/features/history/ui/widgets/mode_distribution_chart_card.dart';
import 'package:sys_control/features/history/ui/widgets/schedule_activity_chart_card.dart';
import 'package:sys_control/features/history/ui/widgets/temperature_chart_card.dart';
import 'package:sys_control/features/history/ui/widgets/zone_comparison_chart_card.dart';
import 'package:sys_control/generated/l10n.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildTimeRangeHeader(context, state.selectedTimeRange, notifier),
                TemperatureChartCard(
                  indoor: state.temperatureHistory.indoor,
                  target: state.temperatureHistory.target,
                ),
                EnergyUsageChartCard(
                  data: state.energyUsage,
                  selectedRange: state.selectedEnergyRange,
                  onRangeChanged: notifier.setEnergyRange,
                ),
                EnergyCostChartCard(data: state.energyCost),
                HumidityChartCard(data: state.humidityHistory),
                ModeDistributionChartCard(data: state.modeDistribution),
                ZoneComparisonChartCard(data: state.zoneComparison),
                ScheduleActivityChartCard(data: state.scheduleActivity),
                const SizedBox(height: 12),
              ],
            ),
    );
  }

  Widget _buildTimeRangeHeader(BuildContext context, HistoryTimeRange selected, HistoryNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            S.of(context).history,
            style: context.customTheme.blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Row(
            children: HistoryTimeRange.values.map((range) {
              final isSelected = range == selected;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child:
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? context.theme.dividerColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? context.customTheme.lightGrayTextStyle.color! : context.theme.dividerColor,
                        ),
                      ),
                      child: Text(
                        range.longName,
                        style: TextStyle(
                          color: isSelected ? context.customTheme.blackTextStyle.color : context.customTheme.grayTextStyle.color,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ).onTap(
                      context: context,
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        notifier.setTimeRange(range);
                      },
                    ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
