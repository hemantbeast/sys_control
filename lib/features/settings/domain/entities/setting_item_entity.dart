class SettingItemEntity {
  const SettingItemEntity({
    required this.id,
    required this.categoryId,
    required this.key,
    required this.label,
    required this.type,
    required this.dataType,
    required this.screenType,
    required this.unit,
    required this.description,
    required this.maxLength,
    required this.sortOrder,
    required this.isReadOnly,
    required this.isVisible,
    this.customScreen,
    this.minValue,
    this.maxValue,
    this.stepValue = 1,
    this.options = const <String>[],
    this.value,
    this.defaultValue,
  });

  final int id;
  final int categoryId;
  final int sortOrder;
  final int maxLength;
  final String key;
  final String label;
  final String type;
  final String dataType;
  final String screenType;
  final String? customScreen;
  final String unit;
  final String description;
  final bool isReadOnly;
  final bool isVisible;
  final double? minValue;
  final double? maxValue;
  final double stepValue;
  final List<String> options;
  final String? value;
  final String? defaultValue;

  double get numericValue => double.tryParse(value ?? defaultValue ?? '') ?? 0;

  bool get boolValue => value == '1' || (value ?? '').toLowerCase() == 'true';

  String get displayValue {
    switch (type) {
      case 'range':
        final number = double.tryParse(value ?? '') ?? 0;
        final formatted = number == number.roundToDouble()
            ? number.round().toString()
            : number.toString();
        return '$formatted$unit';
      case 'toggle':
        return boolValue ? 'On' : 'Off';
      default:
        return value ?? '';
    }
  }
}
