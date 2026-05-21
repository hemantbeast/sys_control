import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:sys_control/app/themes/custom_theme.dart';

extension ContextExt on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get statusBarHeight => MediaQuery.viewPaddingOf(this).top;

  bool get isSmallDevice => screenHeight < 700;

  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  ThemeData get theme => Theme.of(this);

  bool get isDarkTheme => theme.brightness == Brightness.dark;

  CustomTheme get customTheme => theme.extension<CustomTheme>()!;

  List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: theme.colorScheme.shadow.withValues(alpha: isDarkTheme ? 0.3 : 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  double get bottomInset => MediaQuery.viewInsetsOf(this).bottom;

  double get bottomMargin {
    return MediaQuery.viewPaddingOf(this).bottom + 10.0;
  }

  double get bottomPadding {
    return bottomInset > 0 ? bottomInset : bottomMargin;
  }

  // Read a provider using context
  T readProvider<T>(ProviderListenable<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }

  // Read a notifier using context
  T? readNotifier<T, Y>(ProviderBase<Y> provider, Refreshable<T> notifier) {
    if (ProviderScope.containerOf(this, listen: false).exists(provider)) {
      return ProviderScope.containerOf(this, listen: false).read(notifier);
    }
    return null;
  }

  // Refresh provider using context
  T? refreshProvider<T>(ProviderBase<T> provider) {
    if (ProviderScope.containerOf(this, listen: false).exists(provider)) {
      return ProviderScope.containerOf(this, listen: false).refresh(provider);
    } else {
      return null;
    }
  }
}
