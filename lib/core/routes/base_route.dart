import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin BaseRoutes {
  /// Standard transition duration
  static const _transitionDuration = Duration(milliseconds: 250);

  /// Build material page with state preservation
  MaterialPage<void> buildMaterialPage({
    required LocalKey key,
    required Widget child,
    String? name,
    bool maintainState = false,
  }) {
    return MaterialPage(
      key: key,
      name: name,
      child: child,
      maintainState: maintainState,
    );
  }

  /// Build page with custom fade transition
  CustomTransitionPage<void> buildFadePage({
    required LocalKey key,
    required Widget child,
    String? name,
    bool maintainState = false,
  }) {
    return CustomTransitionPage(
      key: key,
      name: name,
      child: child,
      maintainState: maintainState,
      transitionDuration: _transitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    );
  }

  /// Build page with vertical slide transition (bottom to top)
  CustomTransitionPage<void> buildVerticalSlidePage({
    required LocalKey key,
    required Widget child,
    String? name,
    bool maintainState = false,
  }) {
    return CustomTransitionPage(
      key: key,
      name: name,
      child: child,
      maintainState: maintainState,
      transitionDuration: _transitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
