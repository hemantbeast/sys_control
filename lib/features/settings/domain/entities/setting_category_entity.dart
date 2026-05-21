class SettingCategoryEntity {
  const SettingCategoryEntity({
    required this.id,
    required this.key,
    required this.label,
    this.icon = '',
    this.sortOrder = 0,
    this.parentId = -1,
  });

  final int id;
  final int sortOrder;
  final int parentId;
  final String key;
  final String label;
  final String icon;
}
