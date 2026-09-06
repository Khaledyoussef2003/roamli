import 'package:flutter/material.dart';
import 'roamli_colors.dart';

abstract final class RoamliTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: RoamliColors.coral,
      brightness: brightness,
      primary: RoamliColors.coral,
      secondary: RoamliColors.skyBlue,
      surface: dark ? RoamliColors.darkCard : Colors.white,
    );
    final base = ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: 'Inter',
    );
    return base.copyWith(
      scaffoldBackgroundColor: dark ? RoamliColors.darkBackground : RoamliColors.journeySand,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: dark ? Colors.white : RoamliColors.midnight,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(fontFamily: 'Manrope', fontWeight: FontWeight.w800, fontSize: 46, height: 1.08),
        headlineLarge: base.textTheme.headlineLarge?.copyWith(fontFamily: 'Manrope', fontWeight: FontWeight.w800, fontSize: 34, height: 1.16),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(fontFamily: 'Manrope', fontWeight: FontWeight.w700, fontSize: 27, height: 1.2),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(fontFamily: 'Manrope', fontWeight: FontWeight.w700, fontSize: 22, height: 1.25),
        titleLarge: base.textTheme.titleLarge?.copyWith(fontFamily: 'Manrope', fontWeight: FontWeight.w700),
        titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 17, height: 1.48),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.45),
        bodySmall: base.textTheme.bodySmall?.copyWith(fontSize: 13, height: 1.42),
        labelLarge: base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
      ),
      cardTheme: CardThemeData(
        color: dark ? RoamliColors.darkCard : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: dark ? 0 : 0.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: dark ? Colors.white.withValues(alpha: .06) : RoamliColors.sandBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? RoamliColors.darkElevatedCard : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: TextStyle(color: dark ? RoamliColors.darkSecondary : RoamliColors.slate),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: dark ? Colors.white.withValues(alpha: .06) : RoamliColors.sandBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: RoamliColors.coral, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RoamliColors.coral,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: dark ? Colors.white24 : RoamliColors.sandBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: dark ? Colors.white12 : RoamliColors.sandBorder),
      ),
      dividerTheme: DividerThemeData(color: dark ? Colors.white12 : RoamliColors.sandBorder),
    );
  }
}
