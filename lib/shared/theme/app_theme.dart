import 'package:flutter/material.dart';
import 'colors.dart'; // Import the colors file

class AppTheme {
  // Define the light theme (UNCHANGED)
  static ThemeData lightTheme = ThemeData(
    // Global Colors
    primaryColor: kPrimaryColor,
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor, // Standard use of primary color
      secondary: kAccentColor, // Standard use of accent color
      background: kBackgroundColor,
      surface: kSurfaceColor, // Card and background color for light theme
    ),
    scaffoldBackgroundColor: kBackgroundColor,
    cardColor: kSurfaceColor, // Use white for cards
    // AppBar Style
    appBarTheme: const AppBarTheme(
      backgroundColor: kSurfaceColor, // White AppBar
      foregroundColor: kTextColor, // Dark icons/text
      elevation: 1.0,
      centerTitle: true,
    ),

    // Text Theme
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: kTextColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: kTextColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: kTextColor,
      ),
      bodyLarge: TextStyle(fontSize: 16.0, color: kTextColor),
      bodyMedium: TextStyle(fontSize: 14.0, color: kSubtleTextColor),
    ),

    // Button Styles
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: kSurfaceColor, // Text color: White
        backgroundColor: kAccentColor, // Button background: Bright Red/Coral
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: kTextColor),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kAccentColor,
      foregroundColor: kSurfaceColor,
    ),
  );

  // Define the dark theme (NEWLY ADDED)
  static ThemeData darkTheme = ThemeData(
    // Set brightness to Dark
    brightness: Brightness.dark,

    // Global Colors
    primaryColor:
        kPrimaryColor, // Keep primary color the same for brand consistency
    colorScheme: ColorScheme.dark(
      primary: kPrimaryColor,
      secondary: kAccentColor,
      background: Colors.black, // Deep background
      surface: Colors.grey[900]!, // Dark surface for cards/containers
    ),
    scaffoldBackgroundColor: Colors.black, // Dark background
    cardColor: Colors.grey[900], // Dark card color
    // AppBar Style (Dark/Black look)
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black, // Black AppBar
      foregroundColor: Colors.white, // White icons/text
      elevation: 1.0,
      centerTitle: true,
    ),

    // Text Theme (Text is light)
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Light text
      ),
      headlineMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        color: Colors.white70,
      ), // Slightly greyed body text
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: Colors.grey,
      ), // Subtle grey text
    ),

    // Button Styles (Keep accent color consistent)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Text color: White
        backgroundColor: kAccentColor, // Button background: Bright Red/Coral
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: Colors.white),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kAccentColor,
      foregroundColor: Colors.white,
    ),
  );
}
