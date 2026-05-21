import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sys_control/core/database/app_database.dart';
import 'package:sys_control/core/database/database_providers.dart';
import 'package:sys_control/app/themes/light_theme.dart';
import 'package:sys_control/features/settings/ui/settings_landing_widget.dart';
import 'package:sys_control/generated/l10n.dart';

void main() {
  testWidgets('settings landing renders categories from the database', (
    WidgetTester tester,
  ) async {
    final seed = File('assets/database/seed.sql').readAsStringSync();
    final db = AppDatabase(
      executor: NativeDatabase.memory(),
      seedLoader: () async => seed,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          theme: lightTheme,
          localizationsDelegates: const [
            S.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: SettingsLandingWidget(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('General Settings'), findsOneWidget);
    expect(find.text('Display'), findsOneWidget);
    expect(find.text('Audio'), findsOneWidget);
    expect(find.text('Network'), findsOneWidget);

    await db.close();
  });
}
