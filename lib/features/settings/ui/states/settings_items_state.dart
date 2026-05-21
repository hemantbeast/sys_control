import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sys_control/features/settings/domain/entities/setting_item_entity.dart';

part 'settings_items_state.freezed.dart';

@freezed
abstract class SettingsItemsState with _$SettingsItemsState {
  const factory SettingsItemsState({
    @Default(<SettingItemEntity>[]) List<SettingItemEntity> items,
    @Default(true) bool isLoading,
  }) = _SettingsItemsState;

  factory SettingsItemsState.initial() => const SettingsItemsState();
}
