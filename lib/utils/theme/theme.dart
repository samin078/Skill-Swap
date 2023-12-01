
import 'package:flutter/material.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/outlined_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';


class NAppTheme{
  NAppTheme._();
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: NTextTheme.lightTextTheme,
    chipTheme: NChipTheme.lightChipThemeData,
    appBarTheme: NAppBarTheme.lightAppBarTheme,
    checkboxTheme: NCheckBoxTheme.lightCheckBoxTheme,
    bottomSheetTheme: NBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme:NElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: NOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: NTextFormFieldTheme.lightInputDecorationTheme,

  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: NTextTheme.darkTextTheme,
    chipTheme: NChipTheme.darkChipThemeData,
    appBarTheme: NAppBarTheme.darkAppBarTheme,
    checkboxTheme: NCheckBoxTheme.darkCheckBoxTheme,
    bottomSheetTheme: NBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme:NElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: NOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: NTextFormFieldTheme.darkInputDecorationTheme,
  );
}