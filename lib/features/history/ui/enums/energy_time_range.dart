import 'package:sys_control/generated/l10n.dart';

enum EnergyTimeRange {
  weekly,
  monthly,
  yearly;

  String label(S l10n) => switch (this) {
    EnergyTimeRange.weekly => l10n.weekly,
    EnergyTimeRange.monthly => l10n.monthly,
    EnergyTimeRange.yearly => l10n.yearly,
  };
}
