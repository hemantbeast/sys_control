import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/history/domain/entities/history_point_entity.dart';
import 'package:sys_control/features/history/ui/widgets/chart_card_wrapper.dart';
import 'package:sys_control/features/settings/ui/providers/app_settings_provider.dart';
import 'package:sys_control/generated/l10n.dart';

class EnergyCostChartCard extends ConsumerWidget {
  const EnergyCostChartCard({required this.data, super.key});

  final List<HistoryPointEntity> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) return const SizedBox.shrink();

    final l10n = S.of(context);
    final settings = ref.watch(appSettingsProvider);
    final symbol = settings.currency.symbol;

    final values = data.map((e) => e.value).toList();
    final minY = values.reduce((a, b) => a < b ? a : b) - 0.2;
    final maxY = values.reduce((a, b) => a > b ? a : b) + 0.2;
    final avg = values.reduce((a, b) => a + b) / values.length;
    final total = values.reduce((a, b) => a + b);
    final mutedColor = context.customTheme.lightGrayTextStyle.color!;
    final textColor = context.customTheme.blackTextStyle.color!;
    final gridColor = context.theme.colorScheme.outline;

    return ChartCardWrapper(
      title: l10n.energyCost,
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: (maxY - minY) / 4,
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
                        '$symbol${value.toStringAsFixed(2)}',
                        style: TextStyle(color: mutedColor, fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (data.length / 5).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                        final dt = data[idx].timestamp;
                        return Text(
                          '${dt.month}/${dt.day}',
                          style: TextStyle(color: mutedColor, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${l10n.cost}: $symbol${spot.y.toStringAsFixed(2)}',
                        TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
                      );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i].value)),
                    isCurved: true,
                    color: const Color(0xFFFFD166),
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFFD166).withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statItem(l10n.total, '$symbol${total.toStringAsFixed(2)}', textColor, mutedColor),
              _statItem(l10n.dailyAvg, '$symbol${avg.toStringAsFixed(2)}', textColor, mutedColor),
              _statItem(l10n.rate, '$symbol${settings.energyRate.toStringAsFixed(2)}/kWh', textColor, mutedColor),
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
