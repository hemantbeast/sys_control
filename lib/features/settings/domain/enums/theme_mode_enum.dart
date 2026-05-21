import 'package:flutter/material.dart';

enum ThemeModeEnum {
  dark('Dark', ThemeMode.dark),
  light('Light', ThemeMode.light),
  system('System', ThemeMode.system);

  const ThemeModeEnum(this.longName, this.mode);

  final String longName;
  final ThemeMode mode;

  static ThemeModeEnum fromMode(ThemeMode mode) {
    return values.firstWhere(
      (e) => e.mode == mode,
      orElse: () => ThemeModeEnum.dark,
    );
  }
}