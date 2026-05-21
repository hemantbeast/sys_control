import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/routes/app_router.dart';
import 'package:sys_control/app/themes/theme_manager.dart';
import 'package:sys_control/app/widgets/error_view.dart';
import 'package:sys_control/core/database/database_providers.dart';
import 'package:sys_control/features/settings/ui/providers/app_settings_provider.dart';
import 'package:sys_control/generated/l10n.dart';

class SysControlApp extends ConsumerWidget {
  const SysControlApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(externalDbChangeDetectorProvider);
    final theme = ref.watch(themeProvider);
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: 'SysControl',
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.mode,
      locale: Locale(settings.language.code),
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) {
        ErrorWidget.builder = _buildErrorWidget;

        if (child == null) {
          return const SizedBox.shrink();
        }

        return UnFocusWidget(child: child);
      },
    );
  }

  /// Custom error widget builder
  Widget _buildErrorWidget(FlutterErrorDetails errorDetails) {
    return ErrorView(error: errorDetails);
  }
}

class UnFocusWidget extends StatelessWidget {
  const UnFocusWidget({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
