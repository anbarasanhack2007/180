import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color bgPrimary = Color(0xFF080E1A);
  static const Color bgSurface = Color(0xFF0D1626);
  static const Color bgCard = Color(0xFF111C2E);
  static const Color bgElevated = Color(0xFF162035);

  // Cyber Accent Colors
  static const Color cyberCyan = Color(0xFF00E5FF);
  static const Color cyberCyanDim = Color(0xFF00B8D4);
  static const Color cyberBlue = Color(0xFF2979FF);
  static const Color cyberPurple = Color(0xFF7C4DFF);
  static const Color cyberPurpleDim = Color(0xFF651FFF);
  static const Color cyberGreen = Color(0xFF00E676);
  static const Color cyberRed = Color(0xFFFF1744);
  static const Color cyberOrange = Color(0xFFFF6D00);
  static const Color cyberYellow = Color(0xFFFFEA00);
  static const Color cyberPink = Color(0xFFE040FB);

  // Palette Aliases for Rich Cyber Terminology
  static const Color neonPurple = cyberPurple;
  static const Color neonRed = cyberRed;
  static const Color matrixGreen = cyberGreen;
  static const Color neonYellow = cyberYellow;
  static const Color neonCyan = cyberCyan;
  static const Color accentCyan = cyberCyan;
  static const Color accentPurple = cyberPurple;
  static const Color accentGreen = cyberGreen;

  // Gradient
  static const LinearGradient cyberGradient = LinearGradient(
    colors: [cyberCyan, cyberBlue, cyberPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF111C2E), Color(0xFF0D1626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glowGradient = LinearGradient(
    colors: [Color(0x3000E5FF), Color(0x302979FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text
  static const Color textPrimary = Color(0xFFE8F4FD);
  static const Color textSecondary = Color(0xFF8BA0B8);
  static const Color textHint = Color(0xFF4A6580);
  static const Color textMuted = Color(0xFF4A6580);
  static const Color textDisabled = Color(0xFF2D3F52);

  // Border
  static const Color borderColor = Color(0xFF1A2D42);
  static const Color borderGlow = Color(0x3300E5FF);

  // Status
  static const Color statusSuccess = Color(0xFF00E676);
  static const Color statusWarning = Color(0xFFFF6D00);
  static const Color statusError = Color(0xFFFF1744);
  static const Color statusInfo = Color(0xFF2979FF);

  // Progress
  static const Color progressBg = Color(0xFF162035);
  static const Color progressFill = cyberCyan;

  // Month Colors
  static const List<Color> monthColors = [
    Color(0xFF00E5FF), // Month 1 - Cyan
    Color(0xFF2979FF), // Month 2 - Blue
    Color(0xFF7C4DFF), // Month 3 - Purple
    Color(0xFF00E676), // Month 4 - Green
    Color(0xFFFF6D00), // Month 5 - Orange
    Color(0xFFE040FB), // Month 6 - Pink
  ];

  // XP Colors
  static const Color xpGold = Color(0xFFFFD740);
  static const Color xpSilver = Color(0xFFB0BEC5);
  static const Color xpBronze = Color(0xFFFF8A65);

  // Streak
  static const Color streakFire = Color(0xFFFF6D00);

  // Difficulty Colors
  static const Color diffEasy = Color(0xFF00E676);
  static const Color diffMedium = Color(0xFFFFEA00);
  static const Color diffHard = Color(0xFFFF1744);

  // Glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);
}
