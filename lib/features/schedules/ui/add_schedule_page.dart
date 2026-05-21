import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:sys_control/app/routes/app_router.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/core/extensions/gesture_extension.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/domain/enums/repeat_type_enum.dart';
import 'package:sys_control/features/schedules/domain/usecases/process_schedules_usecase.dart';
import 'package:sys_control/features/schedules/ui/providers/add_schedule_provider.dart';
import 'package:sys_control/features/schedules/ui/states/add_schedule_state.dart';
import 'package:sys_control/features/schedules/ui/widgets/repeat_day_bubble.dart';
import 'package:sys_control/features/schedules/ui/widgets/timer_preset_chip.dart';

class AddSchedulePage extends ConsumerStatefulWidget {
  const AddSchedulePage({this.schedule, super.key});

  final ScheduleEntity? schedule;

  @override
  ConsumerState<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends ConsumerState<AddSchedulePage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.schedule != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(addScheduleProvider.notifier).loadForEdit(widget.schedule!);
        _nameController.text = widget.schedule!.name;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addScheduleProvider);
    final notifier = ref.read(addScheduleProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.customTheme.blackTextStyle.color),
          onPressed: AppRouter.pop,
        ),
        title: Text(
          state.isEditing ? 'Edit Schedule' : 'Add Schedule',
          style: context.customTheme.blackTextStyle.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameAndModeRow(state, notifier),
            const SizedBox(height: 20),
            _buildRepeatSection(state, notifier),
            const SizedBox(height: 20),
            _buildDateTimeAndTimerRow(state, notifier),
            const SizedBox(height: 12),
            _buildPreview(state),
            const SizedBox(height: 24),
            _buildFooter(state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndModeRow(AddScheduleState state, AddScheduleNotifier notifier) {
    return Row(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: context.customTheme.grayTextStyle.copyWith(fontSize: 12),
              ),
              TextField(
                controller: _nameController,
                onChanged: notifier.setName,
                style: context.customTheme.blackTextStyle,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mode',
                style: context.customTheme.grayTextStyle.copyWith(fontSize: 12),
              ),
              _buildModeSegmented(state.mode, notifier.setMode),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModeSegmented(ModeEnum currentMode, ValueChanged<ModeEnum> onChanged) {
    final modes = [ModeEnum.heat, ModeEnum.cool, ModeEnum.dry];

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.theme.dividerColor),
      ),
      child: Row(
        children: modes.map((mode) {
          final isSelected = mode == currentMode;

          return Expanded(
            child:
                Container(
                  decoration: BoxDecoration(
                    color: isSelected ? mode.color.withValues(alpha: 0.3) : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    mode.name.toUpperCase(),
                    style: context.customTheme.grayTextStyle.copyWith(
                      color: isSelected ? mode.color : null,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ).onTap(() {
                  onChanged(mode);
                }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRepeatSection(AddScheduleState state, AddScheduleNotifier notifier) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat',
          style: context.customTheme.grayTextStyle.copyWith(fontSize: 12),
        ),
        Row(
          children: RepeatTypeEnum.values.map((type) {
            final isSelected = type == state.repeatType;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child:
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF9D4EDD) : context.theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF9D4EDD) : context.theme.dividerColor,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        type.longName,
                        style: context.customTheme.grayTextStyle.copyWith(
                          color: isSelected ? Colors.white : null,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ).onTap(() {
                      notifier.setRepeatType(type);
                    }),
              ),
            );
          }).toList(),
        ),
        if (state.repeatType == RepeatTypeEnum.weekly) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: RepeatDayBubble(
                  label: labels[index],
                  isSelected: state.repeatDays.contains(index),
                  onTap: () => notifier.toggleRepeatDay(index),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildDateTimeAndTimerRow(AddScheduleState state, AddScheduleNotifier notifier) {
    final label = switch (state.repeatType) {
      RepeatTypeEnum.once => 'Date & Time',
      RepeatTypeEnum.daily || RepeatTypeEnum.weekly => 'Time',
      RepeatTypeEnum.monthly => 'Day & Time',
    };

    const presets = [
      ('5m', 300),
      ('10m', 600),
      ('15m', 900),
      ('30m', 1800),
      ('1h', 3600),
    ];

    return Row(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.customTheme.grayTextStyle.copyWith(fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.theme.dividerColor),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: context.customTheme.lightGrayTextStyle.color),
                    Expanded(
                      child: Text(
                        state.startTime != null ? _formatDateTime(state.startTime!, state.repeatType) : 'Select',
                        style: TextStyle(
                          color: state.startTime != null
                              ? context.customTheme.blackTextStyle.color
                              : context.customTheme.lightGrayTextStyle.color,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ).onTap(() {
                _showDateTimePicker(state, notifier);
              }),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Timer',
                style: context.customTheme.grayTextStyle.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, size: 18, color: context.customTheme.lightGrayTextStyle.color),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.timer > 0 ? _formatDuration(state.timer) : 'Select',
                        style: TextStyle(
                          color: state.timer > 0 ? context.customTheme.blackTextStyle.color : context.customTheme.lightGrayTextStyle.color,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ).onTap(() {
                _showTimerPicker(state, notifier);
              }),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: presets.map((preset) {
                  return TimerPresetChip(
                    label: preset.$1,
                    seconds: preset.$2,
                    isSelected: state.timer == preset.$2,
                    onTap: () => notifier.setTimer(preset.$2),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(AddScheduleState state) {
    if (state.startTime == null || state.timer <= 0) return const SizedBox.shrink();

    final preview = ref
        .read(processSchedulesUseCaseProvider)
        .previewNextOccurrence(
          ScheduleEntity(
            id: 0,
            name: state.name,
            mode: state.mode,
            startTime: state.startTime!,
            timer: state.timer,
            isEnabled: true,
            repeatType: state.repeatType,
            repeatDays: state.repeatDays,
          ),
          DateTime.now(),
        );

    if (preview.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        'Next run: $preview',
        style: context.customTheme.lightGrayTextStyle.copyWith(
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildFooter(AddScheduleState state, AddScheduleNotifier notifier) {
    return Row(
      spacing: 15,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: AppRouter.pop,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.customTheme.grayTextStyle.color,
              side: BorderSide(color: context.customTheme.grayTextStyle.color!),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(0, 45),
            ),
            child: const Text('Cancel'),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final id = await notifier.save();
              if (id != null) {
                await AppRouter.pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 45),
            ),
            child: Text(state.isEditing ? 'Update' : 'Save'),
          ),
        ),
      ],
    );
  }

  void _showDateTimePicker(AddScheduleState state, AddScheduleNotifier notifier) {
    switch (state.repeatType) {
      case RepeatTypeEnum.once:
        _showFullDateTimePicker(notifier);
      case RepeatTypeEnum.daily:
      case RepeatTypeEnum.weekly:
        _showTimePicker(notifier);
      case RepeatTypeEnum.monthly:
        _showDayTimePicker(notifier);
    }
  }

  void _showFullDateTimePicker(AddScheduleNotifier notifier) {
    var selectedDate = state.startTime ?? DateTime.now();
    var selectedHour = selectedDate.hour;
    var selectedMinute = selectedDate.minute;

    showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            'Select Date & Time',
            style: ctx.customTheme.blackTextStyle,
          ),
          content: SizedBox(
            width: 380,
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: ScrollDatePicker(
                    selectedDate: selectedDate,
                    minimumDate: DateTime(2026),
                    maximumDate: DateTime(2030),
                    onDateTimeChanged: (date) {
                      setDialogState(() => selectedDate = date);
                    },
                    options: DatePickerOptions(
                      backgroundColor: ctx.theme.cardColor,
                    ),
                    scrollViewOptions: DatePickerScrollViewOptions.all(
                      ScrollViewDetailOptions(
                        textStyle: ctx.customTheme.blackTextStyle.copyWith(fontSize: 13),
                        selectedTextStyle: ctx.customTheme.blackTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: ctx.theme.dividerColor,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 32,
                          controller: FixedExtentScrollController(initialItem: selectedHour),
                          onSelectedItemChanged: (i) {
                            setDialogState(() => selectedHour = i);
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 24,
                            builder: (ctx, index) => Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  color: index == selectedHour ? ctx.customTheme.blackTextStyle.color : ctx.customTheme.grayTextStyle.color,
                                  fontWeight: index == selectedHour ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ':',
                        style: ctx.customTheme.blackTextStyle.copyWith(fontSize: 20),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 32,
                          controller: FixedExtentScrollController(initialItem: selectedMinute),
                          onSelectedItemChanged: (i) {
                            setDialogState(() => selectedMinute = i);
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 60,
                            builder: (ctx, index) => Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  color: index == selectedMinute
                                      ? ctx.customTheme.blackTextStyle.color
                                      : ctx.customTheme.grayTextStyle.color,
                                  fontWeight: index == selectedMinute ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                notifier.setStartTime(
                  DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedHour,
                    selectedMinute,
                  ),
                );
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(AddScheduleNotifier notifier) {
    var selectedHour = state.startTime?.hour ?? 8;
    var selectedMinute = state.startTime?.minute ?? 0;

    showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            'Select Time',
            style: ctx.customTheme.blackTextStyle,
          ),
          content: SizedBox(
            width: 250,
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 36,
                    controller: FixedExtentScrollController(initialItem: selectedHour),
                    onSelectedItemChanged: (i) {
                      setDialogState(() => selectedHour = i);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 24,
                      builder: (ctx, index) => Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: index == selectedHour ? ctx.customTheme.blackTextStyle.color : ctx.customTheme.grayTextStyle.color,
                            fontWeight: index == selectedHour ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  ':',
                  style: ctx.customTheme.blackTextStyle.copyWith(fontSize: 24),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 36,
                    controller: FixedExtentScrollController(initialItem: selectedMinute),
                    onSelectedItemChanged: (i) {
                      setDialogState(() => selectedMinute = i);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (ctx, index) => Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: index == selectedMinute ? ctx.customTheme.blackTextStyle.color : ctx.customTheme.grayTextStyle.color,
                            fontWeight: index == selectedMinute ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final now = DateTime.now();
                notifier.setStartTime(DateTime(now.year, now.month, now.day, selectedHour, selectedMinute));
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDayTimePicker(AddScheduleNotifier notifier) {
    var selectedDay = state.startTime?.day ?? 1;
    var selectedHour = state.startTime?.hour ?? 8;
    var selectedMinute = state.startTime?.minute ?? 0;

    showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            'Select Day & Time',
            style: ctx.customTheme.blackTextStyle,
          ),
          content: SizedBox(
            width: 300,
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 36,
                    controller: FixedExtentScrollController(initialItem: selectedDay - 1),
                    onSelectedItemChanged: (i) {
                      setDialogState(() => selectedDay = i + 1);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 31,
                      builder: (ctx, index) => Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: index + 1 == selectedDay ? ctx.customTheme.blackTextStyle.color : ctx.customTheme.grayTextStyle.color,
                            fontWeight: index + 1 == selectedDay ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 36,
                    controller: FixedExtentScrollController(initialItem: selectedHour),
                    onSelectedItemChanged: (i) {
                      setDialogState(() => selectedHour = i);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 24,
                      builder: (ctx, index) => Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: index == selectedHour ? ctx.customTheme.blackTextStyle.color : ctx.customTheme.grayTextStyle.color,
                            fontWeight: index == selectedHour ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  ':',
                  style: ctx.customTheme.blackTextStyle.copyWith(fontSize: 24),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 36,
                    controller: FixedExtentScrollController(initialItem: selectedMinute),
                    onSelectedItemChanged: (i) {
                      setDialogState(() => selectedMinute = i);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (ctx, index) => Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: index == selectedMinute ? ctx.customTheme.blackTextStyle.color : ctx.customTheme.grayTextStyle.color,
                            fontWeight: index == selectedMinute ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final now = DateTime.now();
                notifier.setStartTime(DateTime(now.year, now.month, selectedDay, selectedHour, selectedMinute));
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimerPicker(AddScheduleState state, AddScheduleNotifier notifier) {
    var selectedMinutes = state.timer ~/ 60;
    var selectedSeconds = state.timer % 60;

    showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ctx.theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            'Select Duration',
            style: ctx.customTheme.blackTextStyle,
          ),
          content: SizedBox(
            width: 250,
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 36,
                    controller: FixedExtentScrollController(initialItem: selectedMinutes),
                    onSelectedItemChanged: (i) {
                      setDialogState(() => selectedMinutes = i);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (ctx, index) => Center(
                        child: Text(
                          '${index}m',
                          style: TextStyle(
                            color: index == selectedMinutes ? ctx.customTheme.blackTextStyle.color : ctx.customTheme.grayTextStyle.color,
                            fontWeight: index == selectedMinutes ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 36,
                    controller: FixedExtentScrollController(initialItem: selectedSeconds),
                    onSelectedItemChanged: (i) {
                      setDialogState(() => selectedSeconds = i);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (ctx, index) => Center(
                        child: Text(
                          '${index}s',
                          style: TextStyle(
                            color: index == selectedSeconds ? ctx.customTheme.blackTextStyle.color : ctx.customTheme.grayTextStyle.color,
                            fontWeight: index == selectedSeconds ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                notifier.setTimer(selectedMinutes * 60 + selectedSeconds);
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt, RepeatTypeEnum repeatType) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    return switch (repeatType) {
      RepeatTypeEnum.once => '${months[dt.month - 1]} ${dt.day}, ${dt.year}  $timeStr',
      RepeatTypeEnum.daily || RepeatTypeEnum.weekly => timeStr,
      RepeatTypeEnum.monthly => 'Day ${dt.day}  $timeStr',
    };
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (m > 0 && s > 0) return '${m}m ${s}s';
    if (m > 0) return '${m}m';
    return '${s}s';
  }

  AddScheduleState get state => ref.read(addScheduleProvider);
}
