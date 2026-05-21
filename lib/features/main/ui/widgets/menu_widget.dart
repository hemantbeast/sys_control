import 'package:flutter/material.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/core/extensions/widget_extension.dart';
import 'package:sys_control/features/main/ui/providers/main_provider.dart';
import 'package:sys_control/features/main/ui/states/main_state.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    required this.provider,
    required this.notifier,
    super.key,
  });

  final MainState provider;

  final MainNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: context.theme.colorScheme.outline),
        ),
      ),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          provider.menuList.length,
          (index) {
            return SizedBox(
              height: 50,
              child:
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (provider.selectedMenuIndex == index) ...{
                        Positioned(
                          left: 0,
                          child: Container(
                            width: 4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.secondary,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: context.theme.colorScheme.secondary.withValues(alpha: 0.5),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      },
                      Icon(
                        provider.menuList[index].icon as IconData,
                        size: 26,
                        color: provider.selectedMenuIndex == index
                            ? context.theme.colorScheme.secondary
                            : context.customTheme.grayTextStyle.color,
                      ),
                    ],
                  ).onTap(
                    context: context,
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      notifier.selectMenu(index);
                    },
                  ),
            );
          },
        ),
      ),
    );
  }
}
