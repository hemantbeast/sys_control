import 'dart:math';

import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/history/domain/entities/energy_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/history_point_entity.dart';
import 'package:sys_control/features/history/domain/entities/mode_usage_entity.dart';
import 'package:sys_control/features/history/domain/entities/schedule_activity_entity.dart';
import 'package:sys_control/features/history/domain/entities/temperature_history_entity.dart';
import 'package:sys_control/features/history/domain/entities/zone_comparison_entity.dart';

class HistoryMockData {
  static final _random = Random(42);

  static List<HistoryPointEntity> generateTemperatureIndoor() {
    final now = DateTime.now();
    return List.generate(24, (i) {
      final hour = i.toDouble();
      final baseTemp = 22.0 + 3.0 * sin((hour - 6) * pi / 12);
      final noise = (_random.nextDouble() - 0.5) * 1.5;
      return HistoryPointEntity(
        timestamp: now.subtract(Duration(hours: 23 - i)),
        value: double.parse((baseTemp + noise).toStringAsFixed(1)),
      );
    });
  }

  static List<HistoryPointEntity> generateTemperatureTarget() {
    final now = DateTime.now();
    return List.generate(24, (i) {
      final hour = i;
      double target;
      if (hour >= 6 && hour < 9) {
        target = 22.0;
      } else if (hour >= 9 && hour < 17) {
        target = 20.0;
      } else if (hour >= 17 && hour < 22) {
        target = 23.0;
      } else {
        target = 19.0;
      }
      return HistoryPointEntity(
        timestamp: now.subtract(Duration(hours: 23 - i)),
        value: target,
      );
    });
  }

  static TemperatureHistoryEntity temperatureHistory() {
    return TemperatureHistoryEntity(
      indoor: generateTemperatureIndoor(),
      target: generateTemperatureTarget(),
    );
  }

  static List<HistoryPointEntity> generateTemperatureIndoor7d() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final baseTemp = 22.0 + 2.0 * sin(i * pi / 3.5);
      final noise = (_random.nextDouble() - 0.5) * 1.0;
      return HistoryPointEntity(
        timestamp: now.subtract(Duration(days: 6 - i)),
        value: double.parse((baseTemp + noise).toStringAsFixed(1)),
      );
    });
  }

  static List<HistoryPointEntity> generateTemperatureTarget7d() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      return HistoryPointEntity(
        timestamp: now.subtract(Duration(days: 6 - i)),
        value: 22.0 + (_random.nextDouble() - 0.5) * 2,
      );
    });
  }

  static List<HistoryPointEntity> generateTemperatureIndoor30d() {
    final now = DateTime.now();
    return List.generate(30, (i) {
      final baseTemp = 22.0 + 2.5 * sin(i * pi / 15);
      final noise = (_random.nextDouble() - 0.5) * 1.5;
      return HistoryPointEntity(
        timestamp: now.subtract(Duration(days: 29 - i)),
        value: double.parse((baseTemp + noise).toStringAsFixed(1)),
      );
    });
  }

  static List<HistoryPointEntity> generateTemperatureTarget30d() {
    final now = DateTime.now();
    return List.generate(30, (i) {
      return HistoryPointEntity(
        timestamp: now.subtract(Duration(days: 29 - i)),
        value: 22.0 + (_random.nextDouble() - 0.5) * 2,
      );
    });
  }

  static EnergyUsageEntity energyUsageMonthly() {
    final thisYear = [280, 310, 240, 180, 120, 95, 110, 130, 160, 210, 260, 290];
    final lastYear = [300, 330, 260, 195, 135, 105, 120, 145, 175, 225, 275, 310];
    const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return EnergyUsageEntity(
      thisYear: thisYear.map((e) => e.toDouble()).toList(),
      lastYear: lastYear.map((e) => e.toDouble()).toList(),
      labels: labels.toList(),
    );
  }

  static EnergyUsageEntity energyUsageWeekly() {
    final thisWeek = [3.2, 2.8, 3.5, 2.9, 3.1, 4.0, 3.8];
    final lastWeek = [3.5, 3.0, 3.8, 3.1, 3.4, 4.2, 4.0];
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return EnergyUsageEntity(
      thisYear: thisWeek,
      lastYear: lastWeek,
      labels: labels.toList(),
    );
  }

  static EnergyUsageEntity energyUsageYearly() {
    final thisYearTotal = [3200];
    final lastYearTotal = [3500];
    const labels = ['2026'];
    return EnergyUsageEntity(
      thisYear: thisYearTotal.map((e) => e.toDouble()).toList(),
      lastYear: lastYearTotal.map((e) => e.toDouble()).toList(),
      labels: labels.toList(),
    );
  }

  static List<HistoryPointEntity> energyCost() {
    final now = DateTime.now();
    return List.generate(30, (i) {
      final baseUsage = 2.5 + 1.0 * sin(i * pi / 15);
      final noise = (_random.nextDouble() - 0.5) * 0.5;
      final cost = (baseUsage + noise) * 0.15;
      return HistoryPointEntity(
        timestamp: now.subtract(Duration(days: 29 - i)),
        value: double.parse(cost.toStringAsFixed(2)),
      );
    });
  }

  static List<HistoryPointEntity> humidityHistory() {
    final now = DateTime.now();
    return List.generate(24, (i) {
      final baseHumidity = 50.0 - 8.0 * sin((i - 6) * pi / 12);
      final noise = (_random.nextDouble() - 0.5) * 5;
      return HistoryPointEntity(
        timestamp: now.subtract(Duration(hours: 23 - i)),
        value: double.parse((baseHumidity + noise).clamp(30, 70).toStringAsFixed(1)),
      );
    });
  }

  static List<ModeUsageEntity> modeDistribution() {
    return const [
      ModeUsageEntity(mode: ModeEnum.heat, hours: 120, percentage: 40),
      ModeUsageEntity(mode: ModeEnum.cool, hours: 90, percentage: 30),
      ModeUsageEntity(mode: ModeEnum.dry, hours: 45, percentage: 15),
      ModeUsageEntity(mode: ModeEnum.auto, hours: 30, percentage: 10),
      ModeUsageEntity(mode: ModeEnum.fan, hours: 15, percentage: 5),
    ];
  }

  static List<ZoneComparisonEntity> zoneComparison() {
    return [
      const ZoneComparisonEntity(zoneName: 'Living Room', temp: 22.5, humidity: 45),
      const ZoneComparisonEntity(zoneName: 'Master Bedroom', temp: 24.2, humidity: 38),
      const ZoneComparisonEntity(zoneName: 'Kitchen', temp: 21.8, humidity: 52),
      const ZoneComparisonEntity(zoneName: 'Study', temp: 19.5, humidity: 42),
      const ZoneComparisonEntity(zoneName: 'Garage', temp: 16, humidity: 61),
    ];
  }

  static List<ScheduleActivityEntity> scheduleActivity() {
    final now = DateTime.now();
    return List.generate(14, (i) {
      final isWeekday = now.subtract(Duration(days: 13 - i)).weekday <= 5;
      final count = isWeekday ? 2 + _random.nextInt(4) : _random.nextInt(3);
      return ScheduleActivityEntity(
        date: now.subtract(Duration(days: 13 - i)),
        count: count,
      );
    });
  }
}
