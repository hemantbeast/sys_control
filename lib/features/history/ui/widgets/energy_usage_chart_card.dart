import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/history/domain/entities/energy_usage_entity.dart';
import 'package:sys_control/features/history/ui/enums/energy_time_range.dart';
import 'package:sys_control/features/history/ui/widgets/chart_card_wrapper.dart';
import 'package:sys_control/generated/l10n.dart';

class EnergyUsageChartCard extends ConsumerWidget {
  const EnergyUsageChartCard({
    required this.data,
    required this.selectedRange,
    required this.onRangeChanged,
    super.key,
  });

  final EnergyUsageEntity data;
  final EnergyTimeRange selectedRange;
  final ValueChanged<EnergyTimeRange> onRangeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.thisYear.isEmpty) return const SizedBox.shrink();

    final l10n = S.of(context);

    final maxY = [
      ...data.thisYear,
      ...data.lastYear,
    ].reduce((a, b) => a > b ? a : b) * 1.2;

    final totalThisYear = data.thisYear.reduce((a, b) => a + b);
    final totalLastYear = data.lastYear.reduce((a, b) => a + b);
    final change = totalLastYear > 0 ? ((totalThisYear - totalLastYear) / totalLastYear * 100) : 0.0;
    final mutedColor = context.customTheme.lightGrayTextStyle.color!;
    final grayColor = context.customTheme.grayTextStyle.color!;
    final textColor = context.customTheme.blackTextStyle.color!;
    final gridColor = context.theme.colorScheme.outline;
    final dividerColor = context.theme.dividerColor;

    return ChartCardWrapper(
      title: l10n.energyUsage,
      headerRight: _buildRangeSelector(grayColor, dividerColor),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: gridColor,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()} kWh',
                        style: TextStyle(color: mutedColor, fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.labels.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            data.labels[idx],
                            style: TextStyle(color: mutedColor, fontSize: 10),
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
                      final label = rodIndex == 0 ? l10n.lastYear : l10n.thisYear;
                      return BarTooltipItem(
                        '$label: ${rod.toY.toStringAsFixed(0)} kWh',
                        TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
                      );
                    },
                  ),
                ),
                barGroups: List.generate(data.thisYear.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data.lastYear[i],
                        color: const Color(0xFF00B4FF).withValues(alpha: 0.4),
                        width: data.thisYear.length > 6 ? 8 : 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                      BarChartRodData(
                        toY: data.thisYear[i],
                        color: const Color(0xFF00B4FF),
                        width: data.thisYear.length > 6 ? 8 : 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                    ],
                    barsSpace: 2,
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildStats(totalThisYear, totalLastYear, change, textColor, mutedColor, l10n),
        ],
      ),
    );
  }

  Widget _buildRangeSelector(Color grayColor, Color dividerColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: EnergyTimeRange.values.map((range) {
        final isSelected = range == selectedRange;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: GestureDetector(
            onTap: () => onRangeChanged(range),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF00B4FF).withValues(alpha: 0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF00B4FF) : dividerColor,
                ),
              ),
              child: Text(
                range.longName,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF00B4FF) : grayColor,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStats(double totalThisYear, double totalLastYear, double change, Color textColor, Color mutedColor, S l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statItem(l10n.thisYear, '${totalThisYear.toStringAsFixed(0)} kWh', textColor, mutedColor),
        _statItem(l10n.lastYear, '${totalLastYear.toStringAsFixed(0)} kWh', textColor, mutedColor),
        _statItem(l10n.change, '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%', textColor, mutedColor),
      ],
    );
  }

  Widget _statItem(String label, String value, Color textColor, Color mutedColor) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: mutedColor, fontSize: 11)),
      ],
    );
  }
}
