import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class MaterialTheme {
  
  TextTheme textTheme = GoogleFonts.latoTextTheme();
  
  MaterialTheme();

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2e6a44),
      surfaceTint: Color(0xff2e6a44),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb1f1c1),
      onPrimaryContainer: Color(0xff12512e),
      secondary: Color(0xfff36b22), //Color(0xff006874),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff942824), //Color(0xff9eeffd),
      onSecondaryContainer: Color(0xff004f58),
      tertiary: Color(0xff4d662b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffceeda2),
      onTertiaryContainer: Color(0xff364e15),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffef9eb),
      onSurface: Color(0xff1d1c14),
      onSurfaceVariant: Color(0xff414942),
      outline: Color(0xff717971),
      outlineVariant: Color(0xffc1c9bf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323128),
      inversePrimary: Color(0xff96d5a6),
      primaryFixed: Color(0xffb1f1c1),
      onPrimaryFixed: Color(0xff00210e),
      primaryFixedDim: Color(0xff96d5a6),
      onPrimaryFixedVariant: Color(0xff12512e),
      secondaryFixed: Color(0xff9eeffd),
      onSecondaryFixed: Color(0xff001f24),
      secondaryFixedDim: Color(0xff82d3e0),
      onSecondaryFixedVariant: Color(0xff004f58),
      tertiaryFixed: Color(0xffceeda2),
      onTertiaryFixed: Color(0xff112000),
      tertiaryFixedDim: Color(0xffb2d189),
      onTertiaryFixedVariant: Color(0xff364e15),
      surfaceDim: Color(0xffdedacd),
      surfaceBright: Color(0xfffef9eb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f3e6),
      surfaceContainer: Color(0xfff2eee0),
      surfaceContainerHigh: Color(0xffede8da),
      surfaceContainerHighest: Color(0xffe7e2d5),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003f20),
      surfaceTint: Color(0xff2e6a44),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3d7952),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003c44),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff187884),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff263c04),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5b7538),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffef9eb),
      onSurface: Color(0xff12110a),
      onSurfaceVariant: Color(0xff303831),
      outline: Color(0xff4c544d),
      outlineVariant: Color(0xff676f67),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323128),
      inversePrimary: Color(0xff96d5a6),
      primaryFixed: Color(0xff3d7952),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff23603b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff187884),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff005e68),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5b7538),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff435c22),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcac6b9),
      surfaceBright: Color(0xfffef9eb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f3e6),
      surfaceContainer: Color(0xffede8da),
      surfaceContainerHigh: Color(0xffe1ddcf),
      surfaceContainerHighest: Color(0xffd6d1c4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003419),
      surfaceTint: Color(0xff2e6a44),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff155430),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003238),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff00515a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1d3200),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff385017),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffef9eb),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff262e27),
      outlineVariant: Color(0xff434b44),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323128),
      inversePrimary: Color(0xff96d5a6),
      primaryFixed: Color(0xff155430),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003b1d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff00515a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00393f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff385017),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff223902),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbcb9ac),
      surfaceBright: Color(0xfffef9eb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f1e3),
      surfaceContainer: Color(0xffe7e2d5),
      surfaceContainerHigh: Color(0xffd8d4c7),
      surfaceContainerHighest: Color(0xffcac6b9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff96d5a6),
      surfaceTint: Color(0xff96d5a6),
      onPrimary: Color(0xff00391c),
      primaryContainer: Color(0xff12512e),
      onPrimaryContainer: Color(0xffb1f1c1),
      secondary: Color(0xff82d3e0),
      onSecondary: Color(0xff00363d),
      secondaryContainer: Color(0xff004f58),
      onSecondaryContainer: Color(0xff9eeffd),
      tertiary: Color(0xffb2d189),
      onTertiary: Color(0xff203600),
      tertiaryContainer: Color(0xff364e15),
      onTertiaryContainer: Color(0xffceeda2),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff14140c),
      onSurface: Color(0xffe7e2d5),
      onSurfaceVariant: Color(0xffc1c9bf),
      outline: Color(0xff8b938a),
      outlineVariant: Color(0xff414942),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e2d5),
      inversePrimary: Color(0xff2e6a44),
      primaryFixed: Color(0xffb1f1c1),
      onPrimaryFixed: Color(0xff00210e),
      primaryFixedDim: Color(0xff96d5a6),
      onPrimaryFixedVariant: Color(0xff12512e),
      secondaryFixed: Color(0xff9eeffd),
      onSecondaryFixed: Color(0xff001f24),
      secondaryFixedDim: Color(0xff82d3e0),
      onSecondaryFixedVariant: Color(0xff004f58),
      tertiaryFixed: Color(0xffceeda2),
      onTertiaryFixed: Color(0xff112000),
      tertiaryFixedDim: Color(0xffb2d189),
      onTertiaryFixedVariant: Color(0xff364e15),
      surfaceDim: Color(0xff14140c),
      surfaceBright: Color(0xff3b3930),
      surfaceContainerLowest: Color(0xff0f0e07),
      surfaceContainerLow: Color(0xff1d1c14),
      surfaceContainer: Color(0xff212017),
      surfaceContainerHigh: Color(0xff2b2a21),
      surfaceContainerHighest: Color(0xff36352c),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffabebbb),
      surfaceTint: Color(0xff96d5a6),
      onPrimary: Color(0xff002d15),
      primaryContainer: Color(0xff619e73),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff98e9f7),
      onSecondary: Color(0xff002a30),
      secondaryContainer: Color(0xff499ca9),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffc8e79d),
      onTertiary: Color(0xff182b00),
      tertiaryContainer: Color(0xff7e9a58),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff14140c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd6dfd5),
      outline: Color(0xffacb4ab),
      outlineVariant: Color(0xff8a928a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e2d5),
      inversePrimary: Color(0xff13522f),
      primaryFixed: Color(0xffb1f1c1),
      onPrimaryFixed: Color(0xff001507),
      primaryFixedDim: Color(0xff96d5a6),
      onPrimaryFixedVariant: Color(0xff003f20),
      secondaryFixed: Color(0xff9eeffd),
      onSecondaryFixed: Color(0xff001417),
      secondaryFixedDim: Color(0xff82d3e0),
      onSecondaryFixedVariant: Color(0xff003c44),
      tertiaryFixed: Color(0xffceeda2),
      onTertiaryFixed: Color(0xff091400),
      tertiaryFixedDim: Color(0xffb2d189),
      onTertiaryFixedVariant: Color(0xff263c04),
      surfaceDim: Color(0xff14140c),
      surfaceBright: Color(0xff46453b),
      surfaceContainerLowest: Color(0xff080803),
      surfaceContainerLow: Color(0xff1f1e16),
      surfaceContainer: Color(0xff29281f),
      surfaceContainerHigh: Color(0xff34332a),
      surfaceContainerHighest: Color(0xff3f3e34),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbfffce),
      surfaceTint: Color(0xff96d5a6),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff92d1a3),
      onPrimaryContainer: Color(0xff000f04),
      secondary: Color(0xffcdf7ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff7ecfdc),
      onSecondaryContainer: Color(0xff000e10),
      tertiary: Color(0xffdbfbaf),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffafcd85),
      onTertiaryContainer: Color(0xff050e00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff14140c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeaf2e8),
      outlineVariant: Color(0xffbdc5bb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e2d5),
      inversePrimary: Color(0xff13522f),
      primaryFixed: Color(0xffb1f1c1),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff96d5a6),
      onPrimaryFixedVariant: Color(0xff001507),
      secondaryFixed: Color(0xff9eeffd),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff82d3e0),
      onSecondaryFixedVariant: Color(0xff001417),
      tertiaryFixed: Color(0xffceeda2),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb2d189),
      onTertiaryFixedVariant: Color(0xff091400),
      surfaceDim: Color(0xff14140c),
      surfaceBright: Color(0xff525046),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff212017),
      surfaceContainer: Color(0xff323128),
      surfaceContainerHigh: Color(0xff3d3c32),
      surfaceContainerHighest: Color(0xff49473d),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onPrimary,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
