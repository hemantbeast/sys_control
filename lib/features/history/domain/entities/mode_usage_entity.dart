import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';

class ModeUsageEntity {
  const ModeUsageEntity({required this.mode, required this.hours, required this.percentage});

  final ModeEnum mode;
  final double hours;
  final double percentage;
}
