import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/repositories/schedule_repository.dart';

final saveScheduleUseCaseProvider = Provider<SaveScheduleUseCase>((ref) {
  return SaveScheduleUseCase(ref.read(scheduleRepositoryProvider));
});

class SaveScheduleUseCase {
  const SaveScheduleUseCase(this._repository);

  final ScheduleRepository _repository;

  Future<int> create(ScheduleEntity schedule) {
    return _repository.create(schedule);
  }

  Future<void> update(ScheduleEntity schedule) {
    return _repository.update(schedule);
  }
}
