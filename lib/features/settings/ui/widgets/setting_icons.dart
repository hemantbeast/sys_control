import 'package:flutter/material.dart';

const Map<String, IconData> _categoryIcons = <String, IconData>{
  'settings': Icons.settings_outlined,
  'general': Icons.settings_outlined,
  'display': Icons.monitor_outlined,
  'audio': Icons.volume_up_outlined,
  'volume_up': Icons.volume_up_outlined,
  'network': Icons.wifi_outlined,
  'wifi': Icons.wifi_outlined,
  'ac': Icons.ac_unit_rounded,
  'energy': Icons.bolt_rounded,
  'appearance': Icons.palette_outlined,
  'tune': Icons.tune_outlined,
  'schedule': Icons.schedule_outlined,
  'info': Icons.info_outline_rounded,
  'security': Icons.security_outlined,
};

IconData settingCategoryIcon(String name) {
  return _categoryIcons[name] ?? Icons.category_outlined;
}

IconData settingItemIcon(String type) {
  return switch (type) {
    'range' => Icons.tune,
    'dropdown' => Icons.list_alt_rounded,
    'toggle' => Icons.toggle_on_outlined,
    'input' => Icons.edit_outlined,
    'readonly' => Icons.lock_outline_rounded,
    _ => Icons.settings_outlined,
  };
}
