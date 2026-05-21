import 'package:flutter_test/flutter_test.dart';
import 'package:sys_control/core/utils/sql_script_parser.dart';

void main() {
  test('splits statements and skips comments, blanks and pragmas', () {
    const script = '''
-- seed.sql
-- bootstrap script
PRAGMA foreign_keys = ON;

INSERT INTO setting_categories (key, label) VALUES ('general', 'General');
INSERT INTO settings (category_id, key, label)
  VALUES (1, 'brightness', 'Brightness');
''';

    final statements = parseSqlScript(script);

    expect(statements, hasLength(2));
    expect(
      statements.first,
      "INSERT INTO setting_categories (key, label) VALUES ('general', 'General')",
    );
    expect(
      statements.last,
      "INSERT INTO settings (category_id, key, label) VALUES (1, 'brightness', 'Brightness')",
    );
  });

  test('keeps a trailing statement without a semicolon', () {
    const script = 'INSERT INTO a VALUES (1);';

    expect(parseSqlScript(script), ['INSERT INTO a VALUES (1)']);
  });
}
