import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Headings
  static TextStyle heading1 = GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading2 = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading3 = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle heading4 = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Body text
  static TextStyle body = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodyLarge = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodySmall = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Special styles
  static TextStyle moneyLarge = GoogleFonts.roboto(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    letterSpacing: -1,
  );

  static TextStyle moneyMedium = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
  );

  static TextStyle moneySmall = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // Button text
  static TextStyle button = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle buttonLarge = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Caption and labels
  static TextStyle caption = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static TextStyle label = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Table text
  static TextStyle tableHeader = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tableCell = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  // Card title
  static TextStyle cardTitle = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle cardSubtitle = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  // Status text
  static TextStyle statusOnline = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF4CAF50),
  );

  static TextStyle statusOffline = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFF44336),
  );

  // Data text
  static TextStyle data = GoogleFonts.robotoMono(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle dataLarge = GoogleFonts.robotoMono(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
