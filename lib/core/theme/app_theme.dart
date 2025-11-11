import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: const Color(0xFFF7F7FB),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )),
          elevation: WidgetStateProperty.all<double>(4),
          padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          textStyle:
              WidgetStateProperty.all(TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),

      // Card theme — usando CardThemeData quando necessário
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      // Outros componentes
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.6),
      ),

      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        elevation: 6,
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.deepPurple, brightness: Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: const Color(0xFF0F1115),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )),
          elevation: WidgetStateProperty.all<double>(4),
          padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          textStyle:
              WidgetStateProperty.all(TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF16181D),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        elevation: 6,
      ),
    );
  }
}
