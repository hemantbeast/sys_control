import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/dashboard/ui/dashboard_page.dart';
import 'package:sys_control/features/history/ui/history_page.dart';
import 'package:sys_control/features/main/ui/providers/main_provider.dart';
import 'package:sys_control/features/main/ui/widgets/menu_widget.dart';
import 'package:sys_control/features/schedules/ui/schedule_list_page.dart';
import 'package:sys_control/features/settings/ui/settings_landing_widget.dart';
import 'package:sys_control/features/thermostat/ui/thermostat_page.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(mainProvider);
    final notifier = ref.read(mainProvider.notifier);

    return Scaffold(
      body: Row(
        spacing: 10,
        children: [
          MenuWidget(provider: provider, notifier: notifier),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  children: [...previousChildren, if (currentChild != null) currentChild],
                );
              },
              transitionBuilder: (child, animation) {
                final isForward = provider.selectedMenuIndex > provider.previousMenuIndex;
                final isNew = child.key == ValueKey(provider.selectedMenuIndex);

                final begin = isNew
                    ? (isForward ? const Offset(0, 1) : const Offset(0, -1))
                    : (isForward ? const Offset(0, -1) : const Offset(0, 1));

                final offsetAnimation = Tween(begin: begin, end: Offset.zero).animate(animation);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              child: _buildPage(provider.selectedMenuIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    return switch (index) {
      0 => const DashboardPage(key: ValueKey(0)),
      1 => const ThermostatPage(key: ValueKey(1)),
      2 => const ScheduleListPage(key: ValueKey(2)),
      3 => const HistoryPage(key: ValueKey(3)),
      4 => const SettingsLandingWidget(key: ValueKey(4)),
      _ => const DashboardPage(key: ValueKey(0)),
    };
  }
}
