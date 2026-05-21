import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/generated/l10n.dart';

void showSliderDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  required double current,
  required double min,
  required double max,
  required ValueChanged<double> onChanged,
  String unit = '',
  int? divisions,
  int decimal = 0,
}) {
  var temp = current;

  showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: ctx.theme.cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 15, 24, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: ctx.customTheme.blackTextStyle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (ctx, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${temp.toStringAsFixed(decimal)}$unit',
                        style: ctx.customTheme.blackTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        value: temp,
                        min: min,
                        max: max,
                        divisions: divisions ?? (max - min).round(),
                        onChanged: (value) => setState(() => temp = value),
                      ),
                    ],
                  );
                },
              ),
              Row(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                    ),
                    child: Text(S.of(ctx).cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      onChanged(temp);
                      Navigator.pop(ctx);
                    },
                    child: Text(S.of(ctx).save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
