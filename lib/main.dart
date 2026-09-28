import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:sys_control/app/sys_control_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // The database provider is intentionally re-created when the shared db file
  // is replaced wholesale by another app, so a second instance is expected.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode && !kIsWeb) {
      // FirebaseCrashlytics.instance.log('fatal error:\n${details.exceptionAsString()}');
      // FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode && !kIsWeb) {
      // FirebaseCrashlytics.instance.log('error:\n$error\nstack:\n$stack');
      // FirebaseCrashlytics.instance.recordError(error, stack, printDetails: true);
    } else {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stack);
    }
    return true;
  };

  runApp(
    const ProviderScope(
      child: SysControlApp(),
    ),
  );
}
