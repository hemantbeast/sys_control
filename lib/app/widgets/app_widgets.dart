import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/core/extensions/widget_extension.dart';
import 'package:sys_control/generated/assets.dart';

/// Empty widget to show when no data is available.
class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    required this.text,
    this.isSearchResult = false,
    super.key,
  });

  final String text;

  final bool isSearchResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Lottie.asset(
          isSearchResult ? Assets.lottie.noSearchResult : Assets.lottie.emptyData.path,
          frameRate: const FrameRate(60),
          height: 120,
          repeat: true,
          addRepaintBoundary: true,
          options: LottieOptions(enableMergePaths: true),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Loading widget to show when data is loading.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.bgColor});

  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SpinKitDualRing(
        color: context.theme.primaryColor,
        size: 40,
        lineWidth: 5,
      ).toCenter(),
    );
  }
}

/// Shimmer widget to show while loading.
class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({required this.height, required this.width, super.key});

  final double height;

  final double width;

  @override
  Widget build(BuildContext context) {
    return FadeShimmer(
      width: width,
      height: height,
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade700,
    );
  }
}

/// Error widget to show when there is an error.
class ErrorImageWidget extends StatelessWidget {
  const ErrorImageWidget({this.height, this.width, super.key});

  final double? height;

  final double? width;

  @override
  Widget build(BuildContext context) {
    return Assets.icPlaceholder.image(
      fit: BoxFit.cover,
      height: height,
      width: width,
    );
  }
}
