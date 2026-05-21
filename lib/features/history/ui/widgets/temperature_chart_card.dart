import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/history/domain/entities/history_point_entity.dart';
import 'package:sys_control/features/history/ui/widgets/chart_card_wrapper.dart';
import 'package:sys_control/features/settings/domain/enums/temperature_unit_enum.dart';
import 'package:sys_control/features/settings/ui/providers/app_settings_provider.dart';
import 'package:sys_control/generated/l10n.dart';

class TemperatureChartCard extends ConsumerWidget {
  const TemperatureChartCard({
    required this.indoor,
    required this.target,
    super.key,
  });

  final List<HistoryPointEntity> indoor;
  final List<HistoryPointEntity> target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (indoor.isEmpty) return const SizedBox.shrink();

    final l10n = S.of(context);
    final unit = ref.watch(appSettingsProvider).temperatureUnit;
    final displayIndoor = _toDisplayPoints(indoor, unit);
    final displayTarget = _toDisplayPoints(target, unit);

    final minY = [
      ...displayIndoor.map((e) => e.value),
      ...displayTarget.map((e) => e.value),
    ].reduce((a, b) => a < b ? a : b) - 2;
    final maxY = [
      ...displayIndoor.map((e) => e.value),
      ...displayTarget.map((e) => e.value),
    ].reduce((a, b) => a > b ? a : b) + 2;

    final avgIndoor = displayIndoor.map((e) => e.value).reduce((a, b) => a + b) / displayIndoor.length;

    return ChartCardWrapper(
      title: l10n.temperature,
      headerRight: _buildLegend(context, l10n),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
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
                      interval: (displayIndoor.length / 6).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= displayIndoor.length) return const SizedBox.shrink();
                        final dt = displayIndoor[idx].timestamp;
                        return Text(
                          '${dt.hour.toString().padLeft(2, '0')}:00',
                          style: TextStyle(color: context.customTheme.lightGrayTextStyle.color, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final label = spot.barIndex == 0 ? l10n.indoor : l10n.target;
                        final color = spot.barIndex == 0 ? const Color(0xFFFF5F00) : const Color(0xFF00B4FF);
                        return LineTooltipItem(
                          '$label: ${spot.y.toStringAsFixed(1)}${unit.symbol}',
                          TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(displayIndoor.length, (i) => FlSpot(i.toDouble(), displayIndoor[i].value)),
                    isCurved: true,
                    color: const Color(0xFFFF5F00),
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFF5F00).withValues(alpha: 0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: List.generate(displayTarget.length, (i) => FlSpot(i.toDouble(), displayTarget[i].value)),
                    isCurved: true,
                    color: const Color(0xFF00B4FF),
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildStats(avgIndoor, context, unit, l10n),
        ],
      ),
    );
  }

  List<HistoryPointEntity> _toDisplayPoints(List<HistoryPointEntity> points, TemperatureUnitEnum unit) {
    return points.map((e) => HistoryPointEntity(timestamp: e.timestamp, value: unit.toDisplay(e.value))).toList();
  }

  Widget _buildLegend(BuildContext context, S l10n) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 3, color: const Color(0xFFFF5F00)),
        const SizedBox(width: 4),
        Text(l10n.indoor, style: TextStyle(color: context.customTheme.grayTextStyle.color, fontSize: 11)),
        const SizedBox(width: 12),
        Container(width: 12, height: 3, color: const Color(0xFF00B4FF)),
        const SizedBox(width: 4),
        Text(l10n.target, style: TextStyle(color: context.customTheme.grayTextStyle.color, fontSize: 11)),
      ],
    );
  }

  Widget _buildStats(double avg, BuildContext context, TemperatureUnitEnum unit, S l10n) {
    final values = indoor.map((e) => e.value).toList();
    final min = unit.toDisplay(values.reduce((a, b) => a < b ? a : b));
    final max = unit.toDisplay(values.reduce((a, b) => a > b ? a : b));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statItem(l10n.min, '${min.toStringAsFixed(1)}${unit.symbol}', context),
        _statItem(l10n.avg, '${avg.toStringAsFixed(1)}${unit.symbol}', context),
        _statItem(l10n.max, '${max.toStringAsFixed(1)}${unit.symbol}', context),
      ],
    );
  }

  Widget _statItem(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: context.customTheme.blackTextStyle.color, fontSize: 14, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: context.customTheme.lightGrayTextStyle.color, fontSize: 11)),
      ],
    );
  }
}
