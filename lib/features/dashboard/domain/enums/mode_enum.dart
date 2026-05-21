import 'dart:ui';

enum ModeEnum {
  auto(
    longName: 'Auto',
    color: Color(0xFFFFD000),
  ),
  heat(
    longName: 'Heating',
    color: Color(0xFFFF5F00),
  ),
  cool(
    longName: 'Cooling',
    color: Color(0xFF00B4FF),
  ),
  dry(
    longName: 'Dry',
    color: Color(0xFF00FFC2),
  ),
  fan(
    longName: 'Fan',
    color: Color(0xFFBB66FF),
  );

  const ModeEnum({
    required this.longName,
    required this.color,
  });

  final String longName;

  final Color color;
}
