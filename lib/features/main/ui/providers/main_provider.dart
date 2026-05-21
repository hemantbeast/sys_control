import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sys_control/features/main/domain/entities/menu_entity.dart';
import 'package:sys_control/features/main/ui/states/main_state.dart';

final mainProvider = NotifierProvider<MainNotifier, MainState>(MainNotifier.new);

class MainNotifier extends Notifier<MainState> {
  @override
  MainState build() {
    Future.delayed(Duration.zero, _setMenuList);
    return const MainState();
  }

  void _setMenuList() {
    final list = [
      MenuEntity(id: 1, icon: Icons.dashboard_rounded, name: 'Dashboard'),
      MenuEntity(id: 2, icon: Icons.thermostat_rounded, name: 'Thermostat'),
      MenuEntity(id: 3, icon: Icons.schedule_rounded, name: 'Schedules'),
      MenuEntity(id: 4, icon: Icons.bar_chart_rounded, name: 'History'),
      MenuEntity(id: 5, icon: Icons.settings_rounded, name: 'Settings'),
    ];

    state = state.copyWith(menuList: list);
  }

  void selectMenu(int index) {
    state = state.copyWith(previousMenuIndex: state.selectedMenuIndex, selectedMenuIndex: index);
  }
}
