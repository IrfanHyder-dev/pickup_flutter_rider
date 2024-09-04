import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xffF4B755);
const Color secondaryColor = Color(0xffEFEFEF);

const Color darkScaffoldColor = Color(0xffF1F1F1);
const Color lightScaffoldColor = Color(0xffFBFAFA);

const Color darkThemeDarkColor = Color(0xff1D2226);
const Color darkThemeLightColor = Color(0xff3B3F43);
const Color divideColor = Color.fromRGBO(233, 234, 240, 0.15);

const Color darkThemeTextColor = Color(0xff1A1A1A);

const Color darkThemeTextLightColor = Color(0xff969696);
const Color lightThemeTextLightColor = Color(0xff969696);

const Color darkDialogBackgroundColor = Color(0xffE8E8E8);
const Color lightDialogBackgroundColor = Color(0xffE8E8E8);

const Color darkThemeTextGreyColor = Color(0xffBFBFBF);
const Color lightThemeTextGreyColor = Color(0xffBFBFBF);

const Color lightThemeButtonColor = Color(0xff192028);

const Color darkThemeResendBtn = Color(0xffDCDCDD);
const Color profileBackColor = Color(0xff000000);

const Color darkThemeIconColor = Color(0xffBFBFBF);
const Color darkThemeCardColor = Color(0xffFFFFFF);

const Color lightThemeDividerColor = Color(0xffa3a3a3);
// const Color buyCardBackgroundColor = Color(0xffC1F6F7);
// const Color blackCardColor = Color(0xff010F12);
// const Color conversionCardColor = Color(0xff04282F);

const Color redColor = Colors.red;
const Color lightThemeChoseRideBtnColor = Color(0xffF0F4F8);
const Color lightThemeHistoryColor = Color(0xffFCE9CA);
const Color lightThemeFirstGradientColor = Color(0xffFFF8ED);
const Color lightThemeSecondGradientColor = Color(0xffFCCC80);


// const Color iconBackgroundBlue = Color(0xff56B2FF);
// const Color iconBackgroundGreen = Color(0xff6EE7B7);
// const Color iconBackgroundPink = Color(0xffF87171);

String? defaultFontFamily = GoogleFonts.poppins().fontFamily;
String? mulishFontFamily = GoogleFonts.mulish().fontFamily;

abstract class BaseTheme {
  ThemeData get theme;
}
