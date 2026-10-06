import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:florea/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.warmWhite,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.softPurple),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.fraunces(),
        displayMedium: GoogleFonts.fraunces(),
        headlineLarge: GoogleFonts.fraunces(),
      ),
    );
  }
}
