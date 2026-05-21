import 'package:flutter/material.dart';
import 'package:sys_control/core/extensions/context_extension.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: context.theme.colorScheme.onSurface),
      ),
      title: Text(
        title,
        style: context.customTheme.blackTextStyle.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: context.customTheme.grayTextStyle.copyWith(fontSize: 13),
            )
          : null,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: context.customTheme.lightGrayTextStyle.color,
            size: 22,
          ),
      onTap: onTap,
    );
  }
}
