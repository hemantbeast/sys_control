import 'package:sys_control/features/dashboard/domain/enums/fan_speed_enum.dart';
import 'package:sys_control/features/dashboard/domain/enums/mode_enum.dart';
import 'package:sys_control/features/schedules/domain/enums/repeat_type_enum.dart';
import 'package:sys_control/generated/l10n.dart';

extension ModeEnumL10n on ModeEnum {
  String label(S l10n) => switch (this) {
    ModeEnum.auto => l10n.modeAuto,
    ModeEnum.heat => l10n.modeHeat,
    ModeEnum.cool => l10n.modeCool,
    ModeEnum.dry => l10n.modeDry,
    ModeEnum.fan => l10n.modeFan,
  };

  String shortLabel(S l10n) => switch (this) {
    ModeEnum.auto => l10n.modeAuto,
    ModeEnum.heat => l10n.modeHeatShort,
    ModeEnum.cool => l10n.modeCoolShort,
    ModeEnum.dry => l10n.modeDry,
    ModeEnum.fan => l10n.modeFan,
  };

  String description(S l10n) => switch (this) {
    ModeEnum.auto => l10n.modeAutoDesc,
    ModeEnum.heat => l10n.modeHeatDesc,
    ModeEnum.cool => l10n.modeCoolDesc,
    ModeEnum.dry => l10n.modeDryDesc,
    ModeEnum.fan => l10n.modeFanDesc,
  };
}

extension FanSpeedEnumL10n on FanSpeedEnum {
  String label(S l10n) => switch (this) {
    FanSpeedEnum.auto => l10n.fanAuto,
    FanSpeedEnum.low => l10n.fanLow,
    FanSpeedEnum.med => l10n.fanMed,
    FanSpeedEnum.high => l10n.fanHigh,
  };
}

extension RepeatTypeEnumL10n on RepeatTypeEnum {
  String label(S l10n) => switch (this) {
    RepeatTypeEnum.once => l10n.once,
    RepeatTypeEnum.daily => l10n.daily,
    RepeatTypeEnum.weekly => l10n.weekly,
    RepeatTypeEnum.monthly => l10n.monthly,
  };
}
