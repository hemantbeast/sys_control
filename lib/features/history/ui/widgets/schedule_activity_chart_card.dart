import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/history/domain/entities/schedule_activity_entity.dart';
import 'package:sys_control/features/history/ui/widgets/chart_card_wrapper.dart';
import 'package:sys_control/generated/l10n.dart';

class ScheduleActivityChartCard extends ConsumerWidget {
  const ScheduleActivityChartCard({required this.data, super.key});

  final List<ScheduleActivityEntity> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) return const SizedBox.shrink();

    final l10n = S.of(context);
    final maxCount = data.map((e) => e.count).reduce((a, b) => a > b ? a : b) + 1;
    final totalRuns = data.map((e) => e.count).reduce((a, b) => a + b);
    final avgRuns = totalRuns / data.length;
    final mutedColor = context.customTheme.lightGrayTextStyle.color!;
    final gridColor = context.theme.colorScheme.outline;
    final textColor = context.customTheme.blackTextStyle.color!;

    return ChartCardWrapper(
      title: l10n.scheduleActivity,
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxCount.toDouble(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: gridColor,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()} ${l10n.runs}',
                        style: TextStyle(color: mutedColor, fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                        final dt = data[idx].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${dt.day}/${dt.month}',
                            style: TextStyle(color: mutedColor, fontSize: 9),
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
                      final activity = data[group.x];
                      final dayName = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][activity.date.weekday - 1];
                      return BarTooltipItem(
                        '$dayName ${activity.date.day}/${activity.date.month}\n${activity.count} ${l10n.runs}',
                        TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
                      );
                    },
                  ),
                ),
                barGroups: List.generate(data.length, (i) {
                  final isWeekday = data[i].date.weekday <= 5;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].count.toDouble(),
                        color: isWeekday ? const Color(0xFFB77CFF) : const Color(0xFFB77CFF).withValues(alpha: 0.4),
                        width: data.length > 10 ? 10 : 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statItem(l10n.total, '$totalRuns ${l10n.runs}', textColor, mutedColor),
              _statItem(l10n.dailyAvg, '${avgRuns.toStringAsFixed(1)} ${l10n.runs}', textColor, mutedColor),
            ],
          ),
        ],
      ),
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
