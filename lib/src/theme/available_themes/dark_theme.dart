import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../base_theme.dart';

class DarkTheme implements BaseTheme {
  @override
  ThemeData get theme => ThemeData(
        fontFamily: defaultFontFamily,
        brightness: Brightness.light,
        primaryColor: primaryColor,
        primaryColorDark: secondaryColor,
        primaryColorLight: darkThemeLightColor,
        scaffoldBackgroundColor: lightScaffoldColor,
        dialogBackgroundColor: lightDialogBackgroundColor,
        cardColor: lightThemeTextGreyColor,
        canvasColor: lightThemeTextLightColor,
        unselectedWidgetColor: Colors.white,
        dividerColor: lightThemeDividerColor,
        appBarTheme: AppBarTheme(
            backgroundColor: darkScaffoldColor,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: darkThemeTextColor,
              fontFamily: defaultFontFamily,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: darkThemeTextColor,
            fontSize: 40,
            height: 1,
            fontFamily: mulishFontFamily,
            fontWeight: FontWeight.w700,
          ),
          displayMedium: const TextStyle(
              color: darkThemeTextColor,
              fontSize: 16,
              height: 1,
              fontWeight: FontWeight.w400),
          displaySmall: const TextStyle(
            color: darkThemeTextColor,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          headlineLarge: const TextStyle(
            color: darkThemeTextColor,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          headlineMedium: const TextStyle(
            color: darkThemeTextColor,
            fontSize: 16,
            height: 1,
            fontWeight: FontWeight.w500,
          ),
          headlineSmall: const TextStyle(
            color: darkThemeTextColor,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
          titleLarge: TextStyle(
            height: 1,
            color: darkThemeTextColor,
            fontSize: 18,
            fontFamily: mulishFontFamily,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: const TextStyle(
            color: darkThemeTextColor,
            fontSize: 14,
            height: 1,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: const TextStyle(
            color: darkThemeTextColor,
            fontSize: 12,
            height: 1,
            fontWeight: FontWeight.w400,
          ),
          bodyLarge: const TextStyle(
            color: darkThemeTextColor,
            fontSize: 14,
            height: 1,
            fontWeight: FontWeight.w300,
          ),
          bodyMedium: const TextStyle(
            color: darkThemeTextColor,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: const TextStyle(
            color: darkThemeTextLightColor,
            fontSize: 9,
            height: 1,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(
          color: darkThemeIconColor,
          size: 21.0,
        ),
        primaryIconTheme: const IconThemeData(
          color: darkThemeIconColor,
          size: 24.0,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: lightThemeButtonColor,
          ),
        ),
        buttonTheme: const ButtonThemeData(buttonColor: lightThemeButtonColor),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return primaryColor;
              }
              return darkThemeIconColor;
            },
          ),
        ),
      );
}
