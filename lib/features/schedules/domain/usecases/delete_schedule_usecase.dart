import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:sys_control/features/schedules/domain/repositories/schedule_repository.dart';

final deleteScheduleUseCaseProvider = Provider<DeleteScheduleUseCase>((ref) {
  return DeleteScheduleUseCase(ref.read(scheduleRepositoryProvider));
});

class DeleteScheduleUseCase {
  const DeleteScheduleUseCase(this._repository);

  final ScheduleRepository _repository;

  Future<void> delete(int id) {
    return _repository.delete(id);
  }

  Future<void> toggleEnabled(int id, {required bool isEnabled}) {
    return _repository.toggleEnabled(id, isEnabled: isEnabled);
  }
}
