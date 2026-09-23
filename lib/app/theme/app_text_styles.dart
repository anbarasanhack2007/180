import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: const Color(0xFFE8F4FD),
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: const Color(0xFFE8F4FD),
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: const Color(0xFFE8F4FD),
      ),
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: const Color(0xFFE8F4FD),
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: const Color(0xFFE8F4FD),
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: const Color(0xFFE8F4FD),
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: const Color(0xFFE8F4FD),
      ),
      titleMedium: GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: const Color(0xFFE8F4FD),
      ),
      titleSmall: GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: const Color(0xFFE8F4FD),
      ),
      labelLarge: GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        color: const Color(0xFFE8F4FD),
      ),
      labelMedium: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: const Color(0xFFE8F4FD),
      ),
      labelSmall: GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: const Color(0xFFE8F4FD),
      ),
      bodyLarge: GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: const Color(0xFFE8F4FD),
      ),
      bodyMedium: GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: const Color(0xFFE8F4FD),
      ),
      bodySmall: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: const Color(0xFF8BA0B8),
      ),
    );
  }

  // Terminal-style mono font for code snippets
  static TextStyle get mono => GoogleFonts.firaCode(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF00E5FF),
    letterSpacing: 0.5,
  );

  // Cyber glow heading
  static TextStyle get cyberHeading => GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: const Color(0xFF00E5FF),
  );

  // XP number
  static TextStyle get xpNumber => GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: 1,
    color: const Color(0xFFFFD740),
  );
}
