import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.cyan,
  scaffoldBackgroundColor: const Color(0xFF0F1722),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600),
  ),
  textTheme: TextTheme(
    bodyMedium: GoogleFonts.montserrat(),
    headlineMedium: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),
  ),
  cardTheme: CardThemeData(
    color: Color(0xFF111827),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 6,
  ),
  iconTheme: const IconThemeData(size: 20),
  useMaterial3: false,
);
