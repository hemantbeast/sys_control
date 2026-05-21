import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/app/routes/app_router.dart';
import 'package:sys_control/app/themes/colors.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/core/extensions/widget_extension.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/thermostat/ui/providers/thermostat_provider.dart';

class ModeSelectionPage extends ConsumerWidget {
  const ModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(thermostatProvider).mode;
    final notifier = ref.read(thermostatProvider.notifier);

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: AppRouter.pop,
        ),
        title: const Text('Select Mode'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: ModeEnum.values.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final mode = ModeEnum.values[index];
          final isActive = mode == currentMode;

          return _ModeCard(
            mode: mode,
            isActive: isActive,
            onTap: () {
              notifier.setMode(mode);
              AppRouter.pop();
            },
          ).animate().fadeIn(delay: (index * 60).ms).scale(begin: const Offset(0.9, 0.9), duration: 300.ms, curve: Curves.easeOut);
        },
      ).applySafeArea(),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.isActive,
    required this.onTap,
  });

  final ModeEnum mode;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? mode.color.withValues(alpha: 0.08) : context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? mode.color : context.theme.colorScheme.surfaceContainerHighest,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: mode.color.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mode.color.withValues(alpha: 0.12),
            ),
            child: Icon(
              _iconForMode(mode),
              color: mode.color,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            mode.longName,
            style: TextStyle(
              color: isActive ? mode.color : context.customTheme.blackTextStyle.color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _descriptionForMode(mode),
            style: const TextStyle(
              color: slateGray,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).onTap(
      context: context,
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
    );
  }

  IconData _iconForMode(ModeEnum mode) {
    return switch (mode) {
      ModeEnum.auto => Icons.autorenew_rounded,
      ModeEnum.heat => Icons.whatshot_rounded,
      ModeEnum.cool => Icons.ac_unit_rounded,
      ModeEnum.dry => Icons.water_drop_outlined,
      ModeEnum.fan => Icons.air_rounded,
    };
  }

  String _descriptionForMode(ModeEnum mode) {
    return switch (mode) {
      ModeEnum.auto => 'Auto control',
      ModeEnum.heat => 'Warm air',
      ModeEnum.cool => 'Cool air',
      ModeEnum.dry => 'Dehumidify',
      ModeEnum.fan => 'Circulation',
    };
  }
}
