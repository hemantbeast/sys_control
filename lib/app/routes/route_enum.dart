enum RouteEnum {
  splashScreen('/splash'),
  dashboardScreen('/dashboard'),
  modeSelectionScreen('/thermostat/mode'),
  fanSpeedSelectionScreen('/thermostat/fan'),
  scheduleListScreen('/schedules'),
  addScheduleScreen('/schedules/add'),
  settingsScreen('/settings'),
  settingsCategoryScreen('/settings/category'),
  ;

  const RouteEnum(this.path);

  final String path;
}
