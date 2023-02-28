import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juconfession/utils/colors.dart';

class CustomTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
      ).fontFamily,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
      ).fontFamily,
      brightness: Brightness.dark,
    ).copyWith(
      scaffoldBackgroundColor: mobiledarkBackgroundColor,
    );
  }
}
