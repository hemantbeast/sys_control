import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/history/domain/entities/zone_comparison_entity.dart';
import 'package:sys_control/features/history/ui/widgets/chart_card_wrapper.dart';
import 'package:sys_control/features/settings/ui/providers/app_settings_provider.dart';
import 'package:sys_control/generated/l10n.dart';

class ZoneComparisonChartCard extends ConsumerWidget {
  const ZoneComparisonChartCard({required this.data, super.key});

  final List<ZoneComparisonEntity> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) return const SizedBox.shrink();

    final l10n = S.of(context);
    final unit = ref.watch(appSettingsProvider).temperatureUnit;

    final maxTemp = data.map((e) => unit.toDisplay(e.temp)).reduce((a, b) => a > b ? a : b) + 3;

    return ChartCardWrapper(
      title: l10n.zoneComparison,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxTemp,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: context.theme.colorScheme.outline,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}${unit.symbol}',
                        style: TextStyle(color: context.customTheme.lightGrayTextStyle.color, fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            data[idx].zoneName.split(' ').first,
                            style: TextStyle(color: context.customTheme.lightGrayTextStyle.color, fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final zone = data[group.x];
                      return BarTooltipItem(
                        '${zone.zoneName}\n${l10n.temp}: ${unit.toDisplay(zone.temp).toStringAsFixed(1)}${unit.symbol}\n${l10n.humidity}: ${zone.humidity.toStringAsFixed(0)}%',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      );
                    },
                  ),
                ),
                barGroups: List.generate(data.length, (i) {
                  final colors = [
                    const Color(0xFFFF5F00),
                    const Color(0xFF00B4FF),
                    const Color(0xFF00FFC2),
                    const Color(0xFFFFD166),
                    const Color(0xFFBB66FF),
                  ];
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: unit.toDisplay(data[i].temp),
                        color: colors[i % colors.length],
                        width: 28,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: data.map((item) {
              return Text(
                '${item.zoneName}: ${unit.toDisplay(item.temp).toStringAsFixed(1)}${unit.symbol} / ${item.humidity.toStringAsFixed(0)}%',
                style: TextStyle(color: context.customTheme.grayTextStyle.color, fontSize: 11),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
