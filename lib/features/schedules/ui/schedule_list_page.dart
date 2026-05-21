import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/routes/app_router.dart';
import 'package:sys_control/app/routes/route_enum.dart';
import 'package:sys_control/app/themes/colors.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/features/schedules/ui/providers/schedule_list_provider.dart';
import 'package:sys_control/features/schedules/ui/providers/timer_provider.dart';
import 'package:sys_control/features/schedules/ui/widgets/schedule_list_item.dart';

class ScheduleListPage extends ConsumerWidget {
  const ScheduleListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scheduleListProvider);
    final notifier = ref.read(scheduleListProvider.notifier);
    final timerState = ref.watch(timerProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    AppRouter.pushNamed(RouteEnum.addScheduleScreen.name);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Schedule'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: actionColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 40),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.schedules.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    itemCount: state.schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = state.schedules[index];
                      final isRunning = timerState.activeScheduleId == schedule.id;

                      return Dismissible(
                        key: ValueKey(schedule.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: const Color(0xFFEF5350),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return showDialog<bool>(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                backgroundColor: ctx.theme.cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                title: Text(
                                  'Delete Schedule',
                                  style: ctx.customTheme.blackTextStyle,
                                ),
                                content: Text(
                                  'Delete "${schedule.name}"?',
                                  style: ctx.customTheme.grayTextStyle,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Color(0xFFEF5350)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (_) {
                          notifier.deleteSchedule(schedule.id);
                        },
                        child: ScheduleListItem(
                          name: schedule.name,
                          mode: schedule.mode,
                          startTime: schedule.startTime,
                          timer: schedule.timer,
                          isEnabled: schedule.isEnabled,
                          repeatType: schedule.repeatType,
                          isRunning: isRunning,
                          onToggle: (value) {
                            notifier.toggleEnabled(schedule.id, isEnabled: value);
                          },
                          onEdit: () {
                            AppRouter.pushNamed(RouteEnum.addScheduleScreen.name, args: schedule);
                          },
                          onDelete: () {
                            _confirmDelete(context, notifier, schedule.id, schedule.name);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_filled,
            size: 80,
            color: context.customTheme.lightGrayTextStyle.color!.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No Schedules Found',
            style: context.customTheme.blackTextStyle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a schedule to automate your thermostat',
            style: context.customTheme.lightGrayTextStyle.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              AppRouter.pushNamed(RouteEnum.addScheduleScreen.name);
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Schedule'),
            style: ElevatedButton.styleFrom(
              backgroundColor: actionColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(150, 40),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ScheduleListNotifier notifier, int id, String name) {
    showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: ctx.theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Text(
            'Delete Schedule',
            style: ctx.customTheme.blackTextStyle,
          ),
          content: Text(
            'Delete "$name"?',
            style: ctx.customTheme.grayTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                notifier.deleteSchedule(id);
                Navigator.pop(ctx);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFEF5350)),
              ),
            ),
          ],
        );
      },
    );
  }
}
