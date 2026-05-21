import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/history/domain/entities/mode_usage_entity.dart';
import 'package:sys_control/features/history/ui/widgets/chart_card_wrapper.dart';
import 'package:sys_control/generated/l10n.dart';

class ModeDistributionChartCard extends ConsumerWidget {
  const ModeDistributionChartCard({required this.data, super.key});

  final List<ModeUsageEntity> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) return const SizedBox.shrink();

    final l10n = S.of(context);
    final totalHours = data.map((e) => e.hours).reduce((a, b) => a + b);
    final textColor = context.customTheme.blackTextStyle.color!;
    final mutedColor = context.customTheme.lightGrayTextStyle.color!;
    final grayColor = context.customTheme.grayTextStyle.color!;

    return ChartCardWrapper(
      title: l10n.modeDistribution,
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: data.map((item) {
                  return PieChartSectionData(
                    value: item.percentage,
                    color: item.mode.color,
                    radius: 50,
                    title: '${item.percentage.toInt()}%',
                    titleStyle: TextStyle(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: data.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: item.mode.color, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(
                    '${item.mode.longName} (${item.hours.toStringAsFixed(0)}h)',
                    style: TextStyle(color: grayColor, fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.total}: ${totalHours.toStringAsFixed(0)} ${l10n.hours}',
            style: TextStyle(color: mutedColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
