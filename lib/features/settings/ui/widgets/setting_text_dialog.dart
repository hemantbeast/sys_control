import 'package:flutter/material.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/generated/l10n.dart';

void showSettingTextDialog({
  required BuildContext context,
  required String title,
  required String initial,
  required int maxLength,
  required ValueChanged<String> onSaved,
}) {
  final controller = TextEditingController(text: initial);

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
              TextField(
                controller: controller,
                maxLength: maxLength,
                autofocus: true,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                      onSaved(controller.text.trim());
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
