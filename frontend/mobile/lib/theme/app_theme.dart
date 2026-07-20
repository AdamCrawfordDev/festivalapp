import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Brand
  static const Color primary =
      Color(0xFF405FFA);

  static const Color secondary =
      Color(0xFF09B8C8);

  static const Color accent =
      Color(0xFF07240F);

  // Light surfaces
  static const Color background =
      Color(0xFFFCFDFD);

  static const Color surface =
      Color(0xFFFFFFFF);

  static const Color surfaceAlt =
      Color(0xFFF1FAFA);

  // Light text
  static const Color text =
      Color(0xFF07240F);

  static const Color textMuted =
      Color(0xFF4F5A68);

  static const Color textLight =
      Color(0xFFFFFFFF);

  // Borders
  static const Color border =
      Color(0xFFBFDADA);

  static const Color borderStrong =
      Color(0xFF9FC8C8);

  // Status
  static const Color success =
      Color(0xFF2FA56E);

  static const Color warning =
      Color(0xFFE7B63A);

  static const Color error =
      Color(0xFFE24C4C);

  // Dark surfaces
  static const Color darkBackground =
      Color(0xFF07100A);

  static const Color darkSurface =
      Color(0xFF0D1911);

  static const Color darkSurfaceAlt =
      Color(0xFF13241A);

  static const Color darkText =
      Color(0xFFF5FAF7);

  static const Color darkTextMuted =
      Color(0xFFAAB8AF);

  static const Color darkBorder =
      Color(0xFF294033);

  static const Color darkBorderStrong =
      Color(0xFF3A5946);

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: textLight,
      primaryContainer: Color(
        0xFFDDE4FF,
      ),
      onPrimaryContainer: accent,
      secondary: secondary,
      onSecondary: textLight,
      secondaryContainer: Color(
        0xFFD9F8FA,
      ),
      onSecondaryContainer: accent,
      tertiary: accent,
      onTertiary: textLight,
      tertiaryContainer: Color(
        0xFFDCEBDF,
      ),
      onTertiaryContainer: accent,
      error: error,
      onError: textLight,
      errorContainer: Color(
        0xFFFFDAD8,
      ),
      onErrorContainer: Color(
        0xFF410006,
      ),
      surface: surface,
      onSurface: text,
      surfaceContainerHighest:
          surfaceAlt,
      onSurfaceVariant: textMuted,
      outline: border,
      outlineVariant: borderStrong,
      shadow: Color(
        0x1F07240F,
      ),
      scrim: Color(
        0x66000000,
      ),
      inverseSurface: accent,
      onInverseSurface: textLight,
      inversePrimary: Color(
        0xFFB9C4FF,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          background,
      canvasColor: background,
      dividerColor: border,
      fontFamily:
          'PlusJakartaSans',
      textTheme:
          _buildTextTheme(
        baseColor: text,
        mutedColor: textMuted,
      ),
      appBarTheme:
          const AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor:
            Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: text,
          fontFamily: 'Outfit',
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme:
          const CardThemeData(
        color: surface,
        surfaceTintColor:
            Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(
            Radius.circular(16),
          ),
          side: BorderSide(
            color: border,
          ),
        ),
      ),
      navigationBarTheme:
          NavigationBarThemeData(
        height: 68,
        backgroundColor: surface,
        surfaceTintColor:
            Colors.transparent,
        indicatorColor:
            primary.withValues(
          alpha: 0.12,
        ),
        labelTextStyle:
            WidgetStateProperty
                .resolveWith(
          (states) {
            final isSelected =
                states.contains(
              WidgetState.selected,
            );

            return TextStyle(
              fontFamily:
                  'PlusJakartaSans',
              fontSize: 12,
              fontWeight: isSelected
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: isSelected
                  ? primary
                  : textMuted,
            );
          },
        ),
        iconTheme:
            WidgetStateProperty
                .resolveWith(
          (states) {
            final isSelected =
                states.contains(
              WidgetState.selected,
            );

            return IconThemeData(
              color: isSelected
                  ? primary
                  : textMuted,
            );
          },
        ),
      ),
      filledButtonTheme:
          FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textLight,
          textStyle:
              const TextStyle(
            fontFamily:
                'PlusJakartaSans',
            fontWeight:
                FontWeight.w700,
          ),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              10,
            ),
          ),
        ),
      ),
      outlinedButtonTheme:
          OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(
            color: borderStrong,
          ),
          textStyle:
              const TextStyle(
            fontFamily:
                'PlusJakartaSans',
            fontWeight:
                FontWeight.w700,
          ),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              10,
            ),
          ),
        ),
      ),
      inputDecorationTheme:
          InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle:
            const TextStyle(
          color: textMuted,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          borderSide:
              const BorderSide(
            color: border,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          borderSide:
              const BorderSide(
            color: primary,
            width: 2,
          ),
        ),
        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          borderSide:
              const BorderSide(
            color: error,
          ),
        ),
        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          borderSide:
              const BorderSide(
            color: error,
            width: 2,
          ),
        ),
      ),
      dividerTheme:
          const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme:
          const SnackBarThemeData(
        backgroundColor: accent,
        contentTextStyle:
            TextStyle(
          color: textLight,
          fontFamily:
              'PlusJakartaSans',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(
        0xFF9CABFF,
      ),
      onPrimary: Color(
        0xFF001A69,
      ),
      primaryContainer: Color(
        0xFF243FAE,
      ),
      onPrimaryContainer: Color(
        0xFFDDE4FF,
      ),
      secondary: Color(
        0xFF58DCE6,
      ),
      onSecondary: Color(
        0xFF00363B,
      ),
      secondaryContainer: Color(
        0xFF005059,
      ),
      onSecondaryContainer: Color(
        0xFFD9F8FA,
      ),
      tertiary: Color(
        0xFF9CCFA8,
      ),
      onTertiary: Color(
        0xFF07391A,
      ),
      tertiaryContainer: Color(
        0xFF1C522F,
      ),
      onTertiaryContainer: Color(
        0xFFDCEBDF,
      ),
      error: Color(
        0xFFFFB4AB,
      ),
      onError: Color(
        0xFF690005,
      ),
      errorContainer: Color(
        0xFF93000A,
      ),
      onErrorContainer: Color(
        0xFFFFDAD6,
      ),
      surface: darkSurface,
      onSurface: darkText,
      surfaceContainerHighest:
          darkSurfaceAlt,
      onSurfaceVariant:
          darkTextMuted,
      outline: darkBorder,
      outlineVariant:
          darkBorderStrong,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: darkText,
      onInverseSurface:
          darkBackground,
      inversePrimary: primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          darkBackground,
      canvasColor: darkBackground,
      dividerColor: darkBorder,
      fontFamily:
          'PlusJakartaSans',
      textTheme:
          _buildTextTheme(
        baseColor: darkText,
        mutedColor:
            darkTextMuted,
      ),
      appBarTheme:
          const AppBarTheme(
        backgroundColor:
            darkBackground,
        foregroundColor: darkText,
        surfaceTintColor:
            Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: darkText,
          fontFamily: 'Outfit',
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme:
          const CardThemeData(
        color: darkSurface,
        surfaceTintColor:
            Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(
            Radius.circular(16),
          ),
          side: BorderSide(
            color: darkBorder,
          ),
        ),
      ),
      navigationBarTheme:
          NavigationBarThemeData(
        height: 68,
        backgroundColor:
            darkSurface,
        surfaceTintColor:
            Colors.transparent,
        indicatorColor:
            colorScheme.primary
                .withValues(
          alpha: 0.16,
        ),
        labelTextStyle:
            WidgetStateProperty
                .resolveWith(
          (states) {
            final isSelected =
                states.contains(
              WidgetState.selected,
            );

            return TextStyle(
              fontFamily:
                  'PlusJakartaSans',
              fontSize: 12,
              fontWeight: isSelected
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: isSelected
                  ? colorScheme.primary
                  : darkTextMuted,
            );
          },
        ),
        iconTheme:
            WidgetStateProperty
                .resolveWith(
          (states) {
            final isSelected =
                states.contains(
              WidgetState.selected,
            );

            return IconThemeData(
              color: isSelected
                  ? colorScheme.primary
                  : darkTextMuted,
            );
          },
        ),
      ),
      filledButtonTheme:
          FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
          backgroundColor:
              colorScheme.primary,
          foregroundColor:
              colorScheme.onPrimary,
          textStyle:
              const TextStyle(
            fontFamily:
                'PlusJakartaSans',
            fontWeight:
                FontWeight.w700,
          ),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              10,
            ),
          ),
        ),
      ),
      inputDecorationTheme:
          InputDecorationTheme(
        filled: true,
        fillColor:
            darkSurfaceAlt,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle:
            const TextStyle(
          color: darkTextMuted,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          borderSide:
              const BorderSide(
            color: darkBorder,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          borderSide:
              BorderSide(
            color:
                colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      dividerTheme:
          const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme:
          const SnackBarThemeData(
        backgroundColor:
            darkSurfaceAlt,
        contentTextStyle:
            TextStyle(
          color: darkText,
          fontFamily:
              'PlusJakartaSans',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _buildTextTheme({
    required Color baseColor,
    required Color mutedColor,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontFamily:
            'PlusJakartaSans',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontFamily:
            'PlusJakartaSans',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontFamily:
            'PlusJakartaSans',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontFamily:
            'PlusJakartaSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontFamily:
            'PlusJakartaSans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: mutedColor,
      ),
      labelLarge: TextStyle(
        fontFamily:
            'PlusJakartaSans',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontFamily:
            'PlusJakartaSans',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: mutedColor,
      ),
      labelSmall: TextStyle(
        fontFamily:
            'PlusJakartaSans',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: mutedColor,
      ),
    );
  }
}