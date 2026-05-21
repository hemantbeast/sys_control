import 'package:go_router/go_router.dart';
import 'package:sys_control/app/routes/route_enum.dart';
import 'package:sys_control/app/widgets/app_widgets.dart';
import 'package:sys_control/core/routes/base_route.dart';
import 'package:sys_control/features/main/ui/main_page.dart';
import 'package:sys_control/features/schedules/domain/entities/schedule_entity.dart';
import 'package:sys_control/features/schedules/ui/add_schedule_page.dart';
import 'package:sys_control/features/settings/domain/entities/setting_category_entity.dart';
import 'package:sys_control/features/settings/ui/settings_category_page.dart';
import 'package:sys_control/features/settings/ui/settings_page.dart';
import 'package:sys_control/features/splash/ui/splash_page.dart';
import 'package:sys_control/features/thermostat/ui/fan_speed_selection_page.dart';
import 'package:sys_control/features/thermostat/ui/mode_selection_page.dart';

class AppRoutes with BaseRoutes {
  List<RouteBase> get routes => [
    /* Splash */
    GoRoute(
      path: RouteEnum.splashScreen.path,
      name: RouteEnum.splashScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.splashScreen.name,
          child: const SplashPage(),
        );
      },
    ),
    /* Main (Dashboard + Thermostat) */
    GoRoute(
      path: RouteEnum.dashboardScreen.path,
      name: RouteEnum.dashboardScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.dashboardScreen.name,
          child: const MainPage(),
        );
      },
    ),
    /* Mode Selection */
    GoRoute(
      path: RouteEnum.modeSelectionScreen.path,
      name: RouteEnum.modeSelectionScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.modeSelectionScreen.name,
          child: const ModeSelectionPage(),
        );
      },
    ),
    /* Fan Speed Selection */
    GoRoute(
      path: RouteEnum.fanSpeedSelectionScreen.path,
      name: RouteEnum.fanSpeedSelectionScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.fanSpeedSelectionScreen.name,
          child: const FanSpeedSelectionPage(),
        );
      },
    ),
    /* Add Schedule */
    GoRoute(
      path: RouteEnum.addScheduleScreen.path,
      name: RouteEnum.addScheduleScreen.name,
      pageBuilder: (context, state) {
        final schedule = state.extra as ScheduleEntity?;
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.addScheduleScreen.name,
          child: AddSchedulePage(schedule: schedule),
        );
      },
    ),
    /* Settings */
    GoRoute(
      path: RouteEnum.settingsScreen.path,
      name: RouteEnum.settingsScreen.name,
      pageBuilder: (context, state) => buildMaterialPage(
        key: state.pageKey,
        name: RouteEnum.settingsScreen.name,
        child: const SettingsPage(),
      ),
    ),
    /* Settings Category (DB-driven) */
    GoRoute(
      path: RouteEnum.settingsCategoryScreen.path,
      name: RouteEnum.settingsCategoryScreen.name,
      pageBuilder: (context, state) {
        final category = state.extra as SettingCategoryEntity?;
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.settingsCategoryScreen.name,
          child: category == null
              ? const NoDataWidget(text: 'Category not found')
              : SettingsCategoryPage(category: category),
        );
      },
    ),
  ];
}
