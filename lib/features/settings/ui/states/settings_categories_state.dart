import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sys_control/features/settings/domain/entities/setting_category_entity.dart';

part 'settings_categories_state.freezed.dart';

@freezed
abstract class SettingsCategoriesState with _$SettingsCategoriesState {
  const factory SettingsCategoriesState({
    @Default(<SettingCategoryEntity>[]) List<SettingCategoryEntity> categories,
    @Default(true) bool isLoading,
  }) = _SettingsCategoriesState;

  factory SettingsCategoriesState.initial() => const SettingsCategoriesState();
}
