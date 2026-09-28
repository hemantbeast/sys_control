import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Mirrors the Qt scheduler `DbPathResolver`: both apps resolve the shared
/// database in the same order so they always open the same file.
///
/// 1. `db_path` from `<config>/LG/deluxe.json`, if the file exists there
///    (created automatically when missing)
/// 2. Default: `<config>/LG/deluxe.db` — on Windows `%LOCALAPPDATA%/LG/deluxe.db`,
///    matching Qt's `GenericConfigLocation` (legacy `sys_control.sqlite`
///    from the app support directory is copied over on first run when the
///    default location is still empty)
String? lgConfigDirSync() {
  final env = Platform.environment;
  final String base;
  if (Platform.isWindows) {
    final localAppData = env['LOCALAPPDATA'];
    final appData = env['APPDATA'];
    if (localAppData != null && localAppData.isNotEmpty) {
      base = localAppData;
    } else if (appData != null && appData.isNotEmpty) {
      base = p.join(appData, 'Local');
    } else {
      return null;
    }
  } else if (Platform.isMacOS) {
    final home = env['HOME'];
    if (home == null || home.isEmpty) {
      return null;
    }
    base = p.join(home, 'Library', 'Preferences');
  } else {
    final xdg = env['XDG_CONFIG_HOME'];
    if (xdg != null && xdg.isNotEmpty) {
      base = xdg;
    } else {
      final home = env['HOME'];
      if (home == null || home.isEmpty) {
        return null;
      }
      base = p.join(home, '.config');
    }
  }
  return p.join(base, 'LG');
}

String? configuredDatabasePathSync() {
  final dir = lgConfigDirSync();
  if (dir == null) {
    return null;
  }

  final file = File(p.join(dir, 'deluxe.json'));
  if (!file.existsSync()) {
    return null;
  }

  try {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    final dbPath = decoded['db_path'];
    return dbPath is String && dbPath.isNotEmpty ? dbPath : null;
  } on Object {
    return null;
  }
}

Future<void> _migrateLegacyDatabase(String defaultPath) async {
  if (File(defaultPath).existsSync()) {
    return;
  }

  final supportDir = await getApplicationSupportDirectory();
  final legacy = File(p.join(supportDir.path, 'sys_control.sqlite'));
  if (!legacy.existsSync()) {
    return;
  }

  await legacy.copy(defaultPath);
}

Future<bool> _createConfiguredDatabase(String configured) async {
  try {
    final file = File(configured);
    await file.parent.create(recursive: true);
    await file.create();
    return true;
  } on Object {
    return false;
  }
}

Future<String> resolveDatabasePath() async {
  final configured = configuredDatabasePathSync();
  if (configured != null) {
    if (File(configured).existsSync()) {
      return configured;
    }
    if (await _createConfiguredDatabase(configured)) {
      return configured;
    }
    // Configured custom path unusable: fall back to the shared default.
  }

  final dir = lgConfigDirSync();
  if (dir == null) {
    // No usable config location: keep the historical per-app default.
    final supportDir = await getApplicationSupportDirectory();
    return p.join(supportDir.path, 'sys_control.sqlite');
  }

  await Directory(dir).create(recursive: true);
  final defaultPath = p.join(dir, 'deluxe.db');
  await _migrateLegacyDatabase(defaultPath);
  return defaultPath;
}
