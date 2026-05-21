import 'package:flutter/material.dart';
import 'package:sys_control/core/extensions/context_extension.dart';

class ChartCardWrapper extends StatelessWidget {
  const ChartCardWrapper({
    required this.title,
    required this.child,
    this.headerRight,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? headerRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: context.customTheme.blackTextStyle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ?headerRight,
            ],
          ),
          child,
        ],
      ),
    );
  }
}
