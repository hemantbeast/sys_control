import 'dart:async';
import 'dart:io';

import 'package:sys_control/core/database/app_database.dart';

/// Mirrors the Qt scheduler setup: `DatabaseManager::enableExternalChangeDetection`
/// polls `PRAGMA data_version` for commits made by other sqlite connections, and
/// main.cpp watches the database directory for mtime changes (debounced) to catch
/// whole-file replacement from external editors.
class ExternalDbChangeDetector {
  ExternalDbChangeDetector(
    this._db, {
    required void Function() onFileReplaced,
    this.pollInterval = const Duration(seconds: 2),
    this.debounceDelay = const Duration(milliseconds: 300),
  }) : _onFileReplaced = onFileReplaced;

  final AppDatabase _db;
  final void Function() _onFileReplaced;
  final Duration pollInterval;
  final Duration debounceDelay;

  Timer? _pollTimer;
  Timer? _debounceTimer;
  StreamSubscription<FileSystemEvent>? _dirSubscription;
  String? _dbPath;
  int? _lastDataVersion;
  DateTime _lastMtime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime? _mtimeChangedAt;
  bool _directoryWatching = false;
  bool _disposed = false;

  Future<void> start() async {
    try {
      _dbPath = await databaseFilePath();
    } on Object {
      return;
    }
    if (_disposed) {
      return;
    }

    final file = File(_dbPath!);
    _lastDataVersion = await _readDataVersion();
    if (_disposed) {
      return;
    }

    // Stat after the first version read: opening/migrating the database writes
    // the file, and that own write must not look like an external replacement.
    final stat = file.statSync();
    if (stat.type != FileSystemEntityType.notFound) {
      _lastMtime = stat.modified;
    }

    _pollTimer = Timer.periodic(pollInterval, (_) => _poll());

    final directory = Directory(file.parent.path);
    _dirSubscription = directory
        .watch(
          events: FileSystemEvent.create |
              FileSystemEvent.modify |
              FileSystemEvent.move |
              FileSystemEvent.delete,
        )
        .listen(
          (_) => _handleDirectoryEvent(),
          onError: (Object _) => _directoryWatching = false,
        );
    _directoryWatching = true;
  }

  void dispose() {
    _disposed = true;
    _pollTimer?.cancel();
    _debounceTimer?.cancel();
    _dirSubscription?.cancel();
  }

  Future<void> _poll() async {
    if (!_directoryWatching) {
      _handleDirectoryEvent();
    }

    final version = await _readDataVersion();
    if (version == null) {
      return;
    }

    if (_lastDataVersion == null) {
      _lastDataVersion = version;
      return;
    }

    if (version != _lastDataVersion) {
      _lastDataVersion = version;
      _mtimeChangedAt = null;
      _invalidateStreams();
      return;
    }

    // Mtime moved but data_version never followed: the file was replaced by an
    // editor that did not commit through sqlite against our open handle.
    final changedAt = _mtimeChangedAt;
    if (changedAt != null && DateTime.now().difference(changedAt) >= pollInterval) {
      _mtimeChangedAt = null;
      _onFileReplaced();
    }
  }

  void _handleDirectoryEvent() {
    final path = _dbPath;
    if (path == null) {
      return;
    }

    final FileStat stat;
    try {
      stat = File(path).statSync();
    } on FileSystemException {
      return;
    }

    if (stat.type == FileSystemEntityType.notFound) {
      return;
    }
    if (!stat.modified.isAfter(_lastMtime)) {
      return;
    }

    _lastMtime = stat.modified;
    _mtimeChangedAt = DateTime.now();

    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDelay, _invalidateStreams);
  }

  void _invalidateStreams() {
    _db.markTablesUpdated(_db.allTables);
  }

  Future<int?> _readDataVersion() async {
    try {
      final row = await _db.customSelect('PRAGMA data_version').getSingle();
      final value = row.data.values.first;
      return value is int ? value : int.tryParse('$value');
    } on Object {
      return null;
    }
  }
}
