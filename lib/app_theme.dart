import 'package:flutter/material.dart';

class AppTheme {
  // Modern Color Palette
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color deepOrange = Color(0xFFFF4500);
  static const Color lightOrange = Color(0xFFFFB997);

  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color mediumGrey = Color(0xFF424242);
  static const Color lightGrey = Color(0xFFF5F5F5);

  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentRed = Color(0xFFEF5350);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, deepOrange],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF8F3), Color(0xFFFFFFFF)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFFFFBF8)],
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: primaryOrange.withOpacity(0.05),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primaryOrange.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Border Radius
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(20));
  static const BorderRadius buttonRadius =
      BorderRadius.all(Radius.circular(15));
  static const BorderRadius chipRadius = BorderRadius.all(Radius.circular(12));

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryOrange,
        primary: primaryOrange,
        secondary: deepOrange,
        surface: lightGrey,
      ),
      scaffoldBackgroundColor: lightGrey,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: darkGrey,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: cardRadius),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: buttonRadius),
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: buttonRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: buttonRadius,
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: buttonRadius,
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
      ),
      fontFamily: 'Outfit',
    );
  }
}
