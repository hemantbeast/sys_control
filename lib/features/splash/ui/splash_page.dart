import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sys_control/app/routes/app_router.dart';
import 'package:sys_control/app/routes/route_enum.dart';
import 'package:sys_control/app/themes/custom_theme.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/splash/ui/widgets/dot_loader.dart';
import 'package:sys_control/features/splash/ui/widgets/logo_painter.dart';
import 'package:sys_control/generated/l10n.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnim = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), () {
      AppRouter.pushReplacement(RouteEnum.dashboardScreen.name);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.primaryColor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.theme.primaryColor,
              context.theme.colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.scaffoldBackgroundColor,
                    border: Border.all(color: context.theme.colorScheme.secondary, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: context.theme.colorScheme.secondary.withValues(
                          alpha: 0.2 + (_pulseAnim.value * 0.3),
                        ),
                        blurRadius: 16 + (_pulseAnim.value * 20),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: CustomPaint(
                size: const Size(36, 36),
                painter: LogoPainter(),
              ),
            ),
            const SizedBox(height: 28),
            AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: [
                TypewriterAnimatedText(
                  S.of(context).appName.toUpperCase(),
                  textStyle: context.whiteTextStyle.copyWith(fontSize: 36, letterSpacing: 5),
                  speed: const Duration(milliseconds: 90),
                  cursor: '| ',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'MONITOR ⸱ CONTROL ⸱ ANALYSE',
              style: context.whiteTextStyle.copyWith(
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),
            const DotLoader(),
          ],
        ),
      ),
    );
  }
}
