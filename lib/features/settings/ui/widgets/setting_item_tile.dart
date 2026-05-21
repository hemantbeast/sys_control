import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/core/extensions/context_extension.dart';
import 'package:sys_control/core/utils/toast_utils.dart';
import 'package:sys_control/features/settings/domain/entities/setting_item_entity.dart';
import 'package:sys_control/features/settings/ui/providers/settings_items_provider.dart';
import 'package:sys_control/features/settings/ui/widgets/setting_enum_picker.dart';
import 'package:sys_control/features/settings/ui/widgets/setting_icons.dart';
import 'package:sys_control/features/settings/ui/widgets/setting_slider_dialog.dart';
import 'package:sys_control/features/settings/ui/widgets/setting_text_dialog.dart';
import 'package:sys_control/features/settings/ui/widgets/settings_list_tile.dart';
import 'package:sys_control/generated/l10n.dart';

class SettingItemTile extends ConsumerWidget {
  const SettingItemTile({required this.item, super.key});

  final SettingItemEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsListTile(
      icon: settingItemIcon(item.type),
      title: item.label,
      subtitle: item.description.isEmpty ? null : item.description,
      trailing: _buildTrailing(context, ref),
      onTap: item.isReadOnly ? null : () => _openEditor(context, ref),
    );
  }

  Widget _buildTrailing(BuildContext context, WidgetRef ref) {
    switch (item.type) {
      case 'toggle':
        return Switch(
          value: item.boolValue,
          onChanged: item.isReadOnly
              ? null
              : (value) => _save(ref, value ? '1' : '0'),
        );
      default:
        return Text(
          item.displayValue,
          style: context.customTheme.grayTextStyle.copyWith(fontSize: 14),
        );
    }
  }

  void _openEditor(BuildContext context, WidgetRef ref) {
    switch (item.type) {
      case 'range':
        showSliderDialog(
          context: context,
          ref: ref,
          title: item.label,
          current: item.numericValue,
          min: item.minValue ?? 0,
          max: item.maxValue ?? 100,
          unit: item.unit,
          decimal: item.dataType == 'int' ? 0 : 1,
          onChanged: (value) => _save(ref, _formatNumber(value)),
        );
      case 'dropdown':
        showEnumPicker<String>(
          context: context,
          title: item.label,
          options: item.options,
          current: item.value ?? '',
          labelBuilder: (option) => option,
          onSelected: (option) => _save(ref, option),
        );
      case 'input':
        showSettingTextDialog(
          context: context,
          title: item.label,
          initial: item.value ?? '',
          maxLength: item.maxLength,
          onSaved: (value) => _save(ref, value),
        );
    }
  }

  String _formatNumber(double value) {
    return item.dataType == 'int' ? value.round().toString() : value.toString();
  }

  Future<void> _save(WidgetRef ref, String value) async {
    final notifier = ref.read(settingsItemsProvider(item.categoryId).notifier);
    final saved = await notifier.saveValue(item.key, value);

    if (!saved) {
      ToastUtils.showToast(S.current.invalidValue(item.label));
    }
  }
}
