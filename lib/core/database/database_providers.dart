import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/core/database/external_db_change_detector.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  ref.watch(dbGenerationProvider);
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final dbGenerationProvider = NotifierProvider<DbGenerationNotifier, int>(DbGenerationNotifier.new);

class DbGenerationNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void bump() {
    state++;
  }
}

final externalDbChangeDetectorProvider = Provider<ExternalDbChangeDetector>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final detector = ExternalDbChangeDetector(
    database,
    onFileReplaced: () => ref.read(dbGenerationProvider.notifier).bump(),
  );
  ref.onDispose(detector.dispose);
  detector.start();
  return detector;
});
