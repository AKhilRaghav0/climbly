import 'package:flutter/material.dart';

class ClimblyTheme {
  // Light theme colors
  static const Color cream = Color(0xFFF5F5DC);
  static const Color creamLight = Color(0xFFFAFAF5);
  static const Color creamDark = Color(0xFFE8E8D3);
  static const Color charcoal = Color(0xFF2C2C2C);
  static const Color charcoalLight = Color(0xFF404040);
  static const Color charcoalDark = Color(0xFF1A1A1A);
  static const Color gray = Color(0xFF6B6B6B);
  static const Color grayLight = Color(0xFF9B9B9B);
  static const Color grayDark = Color(0xFF4A4A4A);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnSurfaceVariant = Color(0xFFB0B0B0);
  static const Color darkPrimary = Color(0xFFBB86FC);
  static const Color darkSecondary = Color(0xFF03DAC6);

  static ThemeData build({bool isDark = false}) {
    if (isDark) {
      return _buildDarkTheme();
    }
    return _buildLightTheme();
  }

  static ThemeData _buildLightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: charcoal,
        primary: charcoal,
        onPrimary: cream,
        secondary: gray,
        onSecondary: cream,
        surface: cream,
        onSurface: charcoal,
        background: creamLight,
        onBackground: charcoal,
        error: Colors.red.shade700,
        onError: cream,
      ),
      scaffoldBackgroundColor: creamLight,
      dividerColor: grayLight,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: charcoal,
        displayColor: charcoal,
        fontFamily: 'Inter',
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        foregroundColor: charcoal,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: charcoal,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: grayLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: grayLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: charcoal, width: 2),
        ),
        labelStyle: const TextStyle(color: gray),
        hintStyle: const TextStyle(color: grayLight),
      ),
      cardTheme: CardThemeData(
        color: cream,
        elevation: 2,
        shadowColor: charcoal.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: charcoal,
          foregroundColor: cream,
          elevation: 0,
          shadowColor: charcoal.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: charcoal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cream,
        selectedItemColor: charcoal,
        unselectedItemColor: gray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: charcoal,
        unselectedLabelColor: gray,
        indicatorColor: charcoal,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  // Gradient definitions
  static const LinearGradient creamGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [creamLight, cream],
  );

  static const LinearGradient charcoalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [charcoal, charcoalDark],
  );

  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [creamLight, cream],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBackground, darkSurface],
  );

  static ThemeData _buildDarkTheme() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkPrimary,
        primary: darkPrimary,
        onPrimary: darkBackground,
        secondary: darkSecondary,
        onSecondary: darkBackground,
        surface: darkSurface,
        onSurface: darkOnSurface,
        background: darkBackground,
        onBackground: darkOnSurface,
        error: Colors.red.shade400,
        onError: darkBackground,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: darkBackground,
      dividerColor: darkSurfaceVariant,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: darkOnSurface,
        displayColor: darkOnSurface,
        fontFamily: 'Inter',
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkSurfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkSurfaceVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        labelStyle: const TextStyle(color: darkOnSurfaceVariant),
        hintStyle: const TextStyle(color: darkOnSurfaceVariant),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkBackground,
          elevation: 0,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkPrimary,
        unselectedItemColor: darkOnSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: darkPrimary,
        unselectedLabelColor: darkOnSurfaceVariant,
        indicatorColor: darkPrimary,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}


