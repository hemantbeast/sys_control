import 'package:flutter/material.dart';
import 'package:sys_control/core/extensions/context_extension.dart';

void showEnumPicker<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required T current,
  required String Function(T) labelBuilder,
  required ValueChanged<T> onSelected,
}) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 15, 24, 8),
              child: Text(
                title,
                style: ctx.customTheme.blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (ctx, index) {
                  final option = options[index];
                  final isSelected = option == current;

                  return ListTile(
                    shape: index == options.length - 1
                        ? const RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.vertical(bottom: Radius.circular(14)),
                          )
                        : null,
                    title: Text(
                      labelBuilder(option),
                    ),
                    titleTextStyle: TextStyle(
                      color: isSelected ? ctx.customTheme.blackTextStyle.color : ctx.customTheme.grayTextStyle.color,
                    ),
                    trailing: isSelected ? Icon(Icons.check, color: ctx.customTheme.blackTextStyle.color) : null,
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
