import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';

abstract class ScheduleRepository {
  Stream<List<ScheduleEntity>> watchAll();
  Future<int> create(ScheduleEntity schedule);
  Future<void> update(ScheduleEntity schedule);
  Future<void> delete(int id);
  Future<void> toggleEnabled(int id, {required bool isEnabled});
}
