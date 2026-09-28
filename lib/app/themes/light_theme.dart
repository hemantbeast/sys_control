import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sys_control/app/themes/colors.dart';
import 'package:sys_control/app/themes/custom_theme.dart';

const _lightColorScheme = ColorScheme.light(
  primary: Color(0xFF006684),
  primaryContainer: Color(0xFFBCE9FF),
  onPrimaryContainer: Color(0xFF001F2A),
  secondary: Color(0xFF8F4E00),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFFFDCC0),
  onSecondaryContainer: Color(0xFF2E1500),
  tertiary: Color(0xFF006D37),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFF96F7B2),
  onTertiaryContainer: Color(0xFF00210C),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFF8F9FA),
  onSurface: Color(0xFF0D1117),
  surfaceContainerHighest: Color(0xFFDEE3E7),
  onSurfaceVariant: Color(0xFF41484D),
  outline: Color(0xFF71787D),
  shadow: Colors.black,
);

final _lightCustomTheme = CustomTheme(
  blackWhiteColor: Colors.black87,
  whiteBlackColor: Colors.white,
  whiteBgColor: const Color(0xFFFDFDFD),
  shimmerBaseColor: const Color(0xFFE2E8F0),
  shimmerHighlightColor: const Color(0xFFF8FAFC),
  navigationTitleStyle: defaultTextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  blackTextStyle: defaultTextStyle(
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  grayTextStyle: defaultTextStyle(
    color: gray98,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  lightGrayTextStyle: defaultTextStyle(
    color: grayF2,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  whiteTextStyle: defaultTextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
);

final lightTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  colorScheme: _lightColorScheme,
  extensions: [_lightCustomTheme],
  scaffoldBackgroundColor: _lightColorScheme.surface,
  cardColor: Colors.white,
  dividerTheme: DividerThemeData(
    color: _lightColorScheme.outline,
    space: 1,
    thickness: 0.75,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _lightColorScheme.primary,
    foregroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    shadowColor: _lightColorScheme.shadow.withValues(alpha: 0.2),
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: _lightColorScheme.onPrimary,
    backgroundColor: _lightColorScheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 1,
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: defaultTextStyle(
        color: _lightColorScheme.onPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  iconTheme: IconThemeData(
    color: _lightColorScheme.onSurface,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: _lightColorScheme.outline),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _lightColorScheme.outline),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _lightColorScheme.primary),
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: grayF2,
    prefixIconColor: _lightColorScheme.onSurface,
    suffixIconColor: _lightColorScheme.onSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    constraints: const BoxConstraints(minHeight: 45),
    hintStyle: defaultTextStyle(
      color: gray98,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: defaultTextStyle(
      color: _lightColorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: _lightColorScheme.primary,
      minimumSize: const Size(50, 35),
      shadowColor: Colors.transparent,
      textStyle: defaultTextStyle(
        color: _lightColorScheme.primary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? _lightColorScheme.secondaryContainer
          : _lightColorScheme.surfaceContainerHighest,
    ),
    thumbColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? _lightColorScheme.secondary
          : _lightColorScheme.outline,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Colors.white,
    selectedTileColor: grayF2,
    iconColor: gray98,
    textColor: textColor,
  ),
);
