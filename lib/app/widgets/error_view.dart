import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sys_control/core/utils/responsive.dart';
import 'package:sys_control/generated/assets.dart';
import 'package:sys_control/generated/l10n.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, super.key});

  final FlutterErrorDetails error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // try {
            //   final history = NavigationHistoryObserver().history;
            //
            //   if (history.length > 1) {
            //     final lastIndex = history.indexOf(history.last);
            //     final pageSettings = history[lastIndex - 1].settings;
            //
            //     if (pageSettings.name != null && pageSettings.name!.isNotEmpty) {
            //       AppRouter.popUntil(pageSettings.name!);
            //       return;
            //     }
            //   }
            //   AppRouter.startNewRoute(RouteEnum.dashboardScreen.name);
            // } on Exception catch (_) {
            //   AppRouter.startNewRoute(RouteEnum.dashboardScreen.name);
            // }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (Responsive.isSmallPhone(context)) ...{
              const SizedBox(height: 70),
            } else ...{
              const SizedBox(height: 100),
            },
            Assets.lottie.icError.lottie(
              frameRate: const FrameRate(60),
              height: 250,
              width: 250,
              repeat: true,
              addRepaintBoundary: true,
              options: LottieOptions(enableMergePaths: true),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).somethingWentWrong,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).somethingWentWrongDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
