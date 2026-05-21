import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/schedules/data/sources/local/schedule_dao.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/enums/repeat_type_enum.dart';
import 'package:sys_control/features/schedules/domain/repositories/schedule_repository.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepositoryImpl(ref.read(scheduleDaoProvider));
});

class ScheduleRepositoryImpl implements ScheduleRepository {
  const ScheduleRepositoryImpl(this._dao);

  final ScheduleDao _dao;

  @override
  Stream<List<ScheduleEntity>> watchAll() {
    return _dao.watchAll().map(
          (rows) => rows.map(_toEntity).toList(),
        );
  }

  @override
  Future<int> create(ScheduleEntity schedule) {
    return _dao.insert(
      SchedulesTableCompanion.insert(
        name: schedule.name,
        mode: Value(schedule.mode.name),
        startTime: Value(schedule.startTime.toIso8601String()),
        timer: Value(schedule.timer),
        isEnabled: Value(schedule.isEnabled),
        repeatType: Value(schedule.repeatType.index),
        repeatDays: Value(schedule.repeatDays.join(',')),
      ),
    );
  }

  @override
  Future<void> update(ScheduleEntity schedule) async {
    await _dao.update(
      SchedulesTableCompanion(
        id: Value(schedule.id),
        name: Value(schedule.name),
        mode: Value(schedule.mode.name),
        startTime: Value(schedule.startTime.toIso8601String()),
        timer: Value(schedule.timer),
        isEnabled: Value(schedule.isEnabled),
        repeatType: Value(schedule.repeatType.index),
        repeatDays: Value(schedule.repeatDays.join(',')),
      ),
    );
  }

  @override
  Future<void> delete(int id) async {
    await _dao.delete(id);
  }

  @override
  Future<void> toggleEnabled(int id, {required bool isEnabled}) async {
    await _dao.toggleEnabled(id, isEnabled: isEnabled);
  }

  ScheduleEntity _toEntity(SchedulesTableData row) {
    return ScheduleEntity(
      id: row.id,
      name: row.name,
      mode: ModeEnum.values.firstWhere(
        (e) => e.name == (row.mode ?? 'heat'),
        orElse: () => ModeEnum.heat,
      ),
      startTime: row.startTime != null ? DateTime.parse(row.startTime!) : DateTime.now(),
      timer: row.timer ?? 0,
      isEnabled: row.isEnabled ?? false,
      repeatType: RepeatTypeEnum.values[row.repeatType ?? 0],
      repeatDays: (row.repeatDays ?? '').isNotEmpty
          ? row.repeatDays!.split(',').map((e) => int.parse(e.trim())).toList()
          : [],
    );
  }
}
