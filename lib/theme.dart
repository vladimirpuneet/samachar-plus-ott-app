import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Tailwind Default Colors (Approximation)
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  static const Color red500 = Color(0xFFCD1913);
  static const Color blue500 = Color(0xFF3B82F6);
  
  // Primary Brand Color (Assuming a standard blue/red or neutral based on news apps, 
  // but will stick to neutral/red for now as seen in many news apps, or extract from logo if possible.
  // For now, using a clean white/black theme with red accents common in news.)
  static const Color primaryColor = red500; 

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: gray100, // bg-gray-100
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,

        surface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: gray900,
        displayColor: gray900,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: gray900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: gray500,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      // cardTheme: CardTheme(
      //   color: Colors.white,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(8),
      //   ),
      //   margin: EdgeInsets.zero,
      // ),
    );
  }
}
