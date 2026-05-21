List<String> parseSqlScript(String source) {
  final statements = <String>[];
  final current = StringBuffer();

  void flush() {
    final statement = current.toString().trim();
    if (statement.isNotEmpty) {
      statements.add(statement);
    }
    current.clear();
  }

  for (final rawLine in source.split('\n')) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('--') || line.toUpperCase().startsWith('PRAGMA')) {
      continue;
    }

    if (line.endsWith(';')) {
      current.write(line.substring(0, line.length - 1));
      flush();
    } else {
      current.write('$line ');
    }
  }

  flush();
  return statements;
}
