import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sys_control/app/themes/colors.dart';
import 'package:sys_control/app/themes/custom_theme.dart';

const _darkColorScheme = ColorScheme.dark(
  primary: Color(0xFF38BDF8),
  onPrimary: Color(0xFF003546),
  primaryContainer: Color(0xFF004D64),
  onPrimaryContainer: Color(0xFFBCE9FF),
  secondary: Color(0xFFFB923C),
  onSecondary: Color(0xFF4D2700),
  secondaryContainer: Color(0xFF6D3A00),
  onSecondaryContainer: Color(0xFFFFDCC0),
  tertiary: Color(0xFF4ADE80),
  onTertiary: Color(0xFF00391A),
  tertiaryContainer: Color(0xFF005228),
  onTertiaryContainer: Color(0xFF96F7B2),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  onSurface: Color(0xFFE2E2E5),
  surfaceContainerHighest: Color(0xFF21262D),
  onSurfaceVariant: Color(0xFFC1C7CE),
  outline: Color(0xFF8B949E),
  shadow: Colors.black,
);

final _darkCustomTheme = CustomTheme(
  blackWhiteColor: darkTextPrimary,
  whiteBlackColor: darkSurfaceColor,
  whiteBgColor: darkSurfaceColor,
  shimmerBaseColor: const Color(0xFF1C2128),
  shimmerHighlightColor: const Color(0xFF2D333B),
  navigationTitleStyle: defaultTextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  blackTextStyle: defaultTextStyle(
    color: darkTextPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  grayTextStyle: defaultTextStyle(
    color: darkTextSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  lightGrayTextStyle: defaultTextStyle(
    color: darkTextMuted,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  whiteTextStyle: defaultTextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
);

final darkTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  colorScheme: _darkColorScheme,
  extensions: [_darkCustomTheme],
  dividerTheme: DividerThemeData(
    color: _darkColorScheme.outline,
    space: 1,
    thickness: 0.75,
  ),
  cardColor: darkCardColor,
  scaffoldBackgroundColor: _darkColorScheme.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: darkSurfaceColor,
    foregroundColor: darkTextPrimary,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    shadowColor: _darkColorScheme.shadow.withValues(alpha: 0.3),
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: _darkColorScheme.onPrimary,
    backgroundColor: _darkColorScheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 1,
      backgroundColor: _darkColorScheme.primary,
      foregroundColor: _darkColorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: defaultTextStyle(
        color: _darkColorScheme.onPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  iconTheme: IconThemeData(
    color: _darkColorScheme.onSurface,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: _darkColorScheme.outline),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _darkColorScheme.outline),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _darkColorScheme.primary),
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: darkInputColor,
    prefixIconColor: darkTextSecondary,
    suffixIconColor: darkTextSecondary,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    constraints: const BoxConstraints(minHeight: 30),
    hintStyle: defaultTextStyle(
      color: darkTextMuted,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: defaultTextStyle(
      color: darkTextPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: _darkColorScheme.primary,
      minimumSize: const Size(50, 35),
      shadowColor: Colors.transparent,
      textStyle: defaultTextStyle(
        color: _darkColorScheme.primary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: darkSurfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStatePropertyAll(_darkColorScheme.secondaryContainer),
    thumbColor: WidgetStatePropertyAll(_darkColorScheme.secondary),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: darkSurfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.vertical(
        top: Radius.circular(15),
      ),
    ),
  ),
  cardTheme: CardThemeData(
    color: darkCardColor,
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.3),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: darkCardColor,
    selectedTileColor: darkInputColor,
    iconColor: darkTextSecondary,
    textColor: darkTextPrimary,
  ),
);
