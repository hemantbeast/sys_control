import 'package:sys_control/features/history/domain/entities/history_point_entity.dart';

class TemperatureHistoryEntity {
  const TemperatureHistoryEntity({required this.indoor, required this.target});

  final List<HistoryPointEntity> indoor;
  final List<HistoryPointEntity> target;
}
