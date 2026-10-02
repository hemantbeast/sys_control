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
    this.dbPathOverride,
    this.pollInterval = const Duration(seconds: 2),
    this.debounceDelay = const Duration(milliseconds: 300),
  }) : _onFileReplaced = onFileReplaced;

  final AppDatabase _db;
  final void Function() _onFileReplaced;
  final String? dbPathOverride;
  final Duration pollInterval;
  final Duration debounceDelay;

  static const int _maxFailedPolls = 3;

  Timer? _pollTimer;
  Timer? _debounceTimer;
  StreamSubscription<FileSystemEvent>? _dirSubscription;
  String? _dbPath;
  int? _lastDataVersion;
  int _failedPolls = 0;
  DateTime _lastMtime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _birthTime = DateTime.fromMillisecondsSinceEpoch(0);
  bool _directoryWatching = false;
  bool _disposed = false;

  Future<void> start() async {
    try {
      _dbPath = dbPathOverride ?? await databaseFilePath();
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
      _birthTime = stat.changed;
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
      _failedPolls++;
      if (_failedPolls >= _maxFailedPolls) {
        _failedPolls = 0;
        _onFileReplaced();
      }
      return;
    }
    _failedPolls = 0;

    if (_lastDataVersion == null) {
      _lastDataVersion = version;
      return;
    }

    if (version != _lastDataVersion) {
      _lastDataVersion = version;
      _invalidateStreams();
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

    // ponytail: FileStat.changed is the file creation time on Windows, and an
    // in-place commit can never move it, so this is the whole-file-replacement
    // signal here. On other platforms changed() moves on writes too, so
    // replacement falls through to the failed-poll escalation in _poll().
    // Upgrade path: compare file ids (GetFileInformationByHandle/statx).
    if (Platform.isWindows && stat.changed != _birthTime) {
      _birthTime = stat.changed;
      _lastMtime = stat.modified;
      _debounceTimer?.cancel();
      _debounceTimer = Timer(debounceDelay, _onFileReplaced);
      return;
    }

    if (!stat.modified.isAfter(_lastMtime)) {
      return;
    }

    _lastMtime = stat.modified;
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
