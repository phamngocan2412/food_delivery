import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the Food Delivery application.
class AppTheme {
  AppTheme._();

  // Primary colors
  static const Color primary = Color(0xFFF97316);
  static const Color primaryLight = Color(0xFFFB923C);
  static const Color primaryDark = Color(0xFFEA580C);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray900 = Color(0xFF111827);

  // Semantic colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color delivery = Color(0xFF6366F1);
  static const Color loyalty = Color(0xFFA855F7);

  // Light theme colors
  static const Color backgroundLight = white;
  static const Color surfaceLight = white;
  static const Color cardLight = gray50;
  static const Color dividerLight = gray200;
  static const Color shadowLight = Color(0x1F000000);
  static const Color textHighEmphasisLight = gray900;
  static const Color textMediumEmphasisLight = gray700;
  static const Color textDisabledLight = gray500;

  // Dark theme colors
  static const Color backgroundDark = gray900;
  static const Color surfaceDark = gray900;
  static const Color cardDark = gray700;
  static const Color dividerDark = gray700;
  static const Color shadowDark = Color(0x1FFFFFFF);
  static const Color textHighEmphasisDark = white;
  static const Color textMediumEmphasisDark = gray200;
  static const Color textDisabledDark = gray500;

  /// Light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: white,
      primaryContainer: primaryLight,
      onPrimaryContainer: gray900,
      secondary: delivery,
      onSecondary: white,
      secondaryContainer: Color(0xFFE0E0FF),
      onSecondaryContainer: Color(0xFF000080),
      tertiary: loyalty,
      onTertiary: white,
      tertiaryContainer: Color(0xFFF5E0FF),
      onTertiaryContainer: Color(0xFF4B0082),
      error: error,
      onError: white,
      surface: surfaceLight,
      onSurface: textHighEmphasisLight,
      surfaceContainerHighest: cardLight,
      onSurfaceVariant: textMediumEmphasisLight,
      outline: dividerLight,
      outlineVariant: gray300,
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: gray900,
      onInverseSurface: white,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    dividerColor: dividerLight,
    appBarTheme: const AppBarTheme(
      color: white,
      foregroundColor: gray900,
      elevation: 0.5,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: gray900,
      ),
      iconTheme: IconThemeData(color: gray900),
    ),
    cardTheme: CardTheme(
      color: white,
      elevation: 2.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: primary,
      unselectedItemColor: gray500,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
      elevation: 4.0,
      shape: CircleBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: white,
        backgroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 2.0,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        side: const BorderSide(color: primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: true),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: gray50,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: error, width: 2.0),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: gray700,
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: gray500,
      ),
      prefixIconColor: gray500,
      suffixIconColor: gray500,
      errorStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: error,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return gray300;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary.withAlpha(77);
        }
        return gray200;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return null;
      }),
      checkColor: WidgetStateProperty.all(white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return null;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      circularTrackColor: gray200,
      linearTrackColor: gray200,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primary,
      thumbColor: primary,
      overlayColor: primary.withAlpha(51),
      inactiveTrackColor: gray300,
      trackHeight: 4.0,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primary,
      unselectedLabelColor: gray500,
      indicatorColor: primary,
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: gray900.withAlpha(230),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: white,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: gray900,
      contentTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: white,
      ),
      actionTextColor: primaryLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: gray100,
      disabledColor: gray200,
      selectedColor: primary.withAlpha(51),
      secondarySelectedColor: primary.withAlpha(51),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: gray700,
      ),
      secondaryLabelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 8.0,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8.0,
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: gray900,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: gray700,
      ),
    ),
  );

  /// Dark theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryLight,
      onPrimary: gray900,
      primaryContainer: primary,
      onPrimaryContainer: white,
      secondary: delivery,
      onSecondary: white,
      secondaryContainer: Color(0xFF3A3D8C),
      onSecondaryContainer: Color(0xFFE0E0FF),
      tertiary: loyalty,
      onTertiary: white,
      tertiaryContainer: Color(0xFF6A3A8C),
      onTertiaryContainer: Color(0xFFF5E0FF),
      error: error,
      onError: white,
      surface: surfaceDark,
      onSurface: textHighEmphasisDark,
      surfaceContainerHighest: cardDark,
      onSurfaceVariant: textMediumEmphasisDark,
      outline: dividerDark,
      outlineVariant: gray700,
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: white,
      onInverseSurface: gray900,
      inversePrimary: primary,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: dividerDark,
    appBarTheme: const AppBarTheme(
      color: gray900,
      foregroundColor: white,
      elevation: 0.5,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: white,
      ),
      iconTheme: IconThemeData(color: white),
    ),
    cardTheme: CardTheme(
      color: gray700,
      elevation: 2.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: gray900,
      selectedItemColor: primaryLight,
      unselectedItemColor: gray300,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: gray900,
      elevation: 4.0,
      shape: CircleBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: gray900,
        backgroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 2.0,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        side: const BorderSide(color: primaryLight, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: gray700,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryLight, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: error, width: 2.0),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: gray200,
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: gray500,
      ),
      prefixIconColor: gray300,
      suffixIconColor: gray300,
      errorStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: error,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return gray500;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withAlpha(77);
        }
        return gray700;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return null;
      }),
      checkColor: WidgetStateProperty.all(gray900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return null;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryLight,
      circularTrackColor: gray700,
      linearTrackColor: gray700,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryLight,
      thumbColor: primaryLight,
      overlayColor: primaryLight.withAlpha(51),
      inactiveTrackColor: gray700,
      trackHeight: 4.0,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primaryLight,
      unselectedLabelColor: gray300,
      indicatorColor: primaryLight,
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: gray300.withAlpha(230),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: gray900,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: gray700,
      contentTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: white,
      ),
      actionTextColor: primaryLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: gray700,
      disabledColor: gray700.withAlpha(128),
      selectedColor: primaryLight.withAlpha(51),
      secondarySelectedColor: primaryLight.withAlpha(51),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: gray200,
      ),
      secondaryLabelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryLight,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: gray700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 8.0,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: gray700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8.0,
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: white,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: gray200,
      ),
    ),
  );

  /// Helper method to build text theme based on brightness
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    // Using Google Fonts to apply Inter and DM Sans
    final TextTheme baseTextTheme = GoogleFonts.interTextTheme();
    final TextTheme accentTextTheme = GoogleFonts.dmSansTextTheme();

    return TextTheme(
      // Display styles
      displayLarge: baseTextTheme.displayLarge!.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: textHighEmphasis,
        letterSpacing: -0.5,
      ),
      displayMedium: baseTextTheme.displayMedium!.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textHighEmphasis,
        letterSpacing: -0.25,
      ),
      displaySmall: baseTextTheme.displaySmall!.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),

      // Body styles
      bodyLarge: baseTextTheme.bodyLarge!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      bodyMedium: baseTextTheme.bodyMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      bodySmall: baseTextTheme.bodySmall!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),

      // Label styles (using DM Sans for accent)
      labelLarge: accentTextTheme.labelLarge!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        textBaseline: TextBaseline.alphabetic,
      ),

      // Price style (using DM Sans for accent)
      titleLarge: accentTextTheme.titleLarge!.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),

      // Headline styles
      headlineLarge: baseTextTheme.headlineLarge!.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: textHighEmphasis,
      ),
      headlineMedium: baseTextTheme.headlineMedium!.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textHighEmphasis,
      ),
      headlineSmall: baseTextTheme.headlineSmall!.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),

      // Title styles
      titleMedium: baseTextTheme.titleMedium!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleSmall: baseTextTheme.titleSmall!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),

      // Other label styles
      labelMedium: baseTextTheme.labelMedium!.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
      ),
      labelSmall: baseTextTheme.labelSmall!.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textDisabled,
        letterSpacing: 0.5,
        textBaseline: TextBaseline.alphabetic,
      ),
    );
  }

  /// Theme mode helper
  static ThemeMode getThemeMode(String mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
