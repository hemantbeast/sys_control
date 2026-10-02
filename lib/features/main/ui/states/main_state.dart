import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sys_control/features/main/domain/entities/menu_entity.dart';

part 'main_state.freezed.dart';

@freezed
abstract class MainState with _$MainState {
  const factory MainState({
    @Default([]) List<MenuEntity> menuList,
    @Default(0) int selectedMenuIndex,
    @Default(0) int previousMenuIndex,
  }) = _MainState;

  factory MainState.initial() => const MainState();
}
