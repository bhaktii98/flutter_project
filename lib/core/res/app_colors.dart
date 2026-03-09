import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Adapted from lib copy AppColors
  static const Color themeColor = Color.fromRGBO(89, 120, 247, 1);
  static const Color primaryColor = Color.fromRGBO(87, 51, 83, 1);
  static const Color secondaryColor = Color.fromRGBO(27, 35, 126, 1);

  static const Color cardColor = Colors.white;
  static final Color cardBorderColor =
      AppColors.primaryColor.withValues(alpha: 0.15);
  static const Color surface = cardColor;

  static const Color fieldBackgroundColor =
      Color.fromRGBO(177, 175, 233, 0.1);

  static const Color accentColor = Color.fromRGBO(220, 156, 19, 1);
  static const Color errorColor = Color.fromRGBO(211, 47, 47, 1);
  static const Color warningColor = Color.fromRGBO(255, 160, 0, 1);
  static const Color successColor = Color.fromRGBO(56, 142, 60, 1);

  static const Color dividerColor = Color.fromRGBO(189, 189, 189, 1);

  static const List<Color> scaffoldGradientColors = [
    Color.fromRGBO(255, 255, 255, 1),
    Color.fromRGBO(251, 238, 250, 1),
  ];

  static const List<Color> primaryGradientColors = [
    Color.fromRGBO(111, 140, 255, 1),
    Color.fromRGBO(156, 132, 255, 1),
  ];

  static const List<Color> secondaryGradientColors = [
    Color.fromRGBO(89, 120, 247, 1),
    Color.fromRGBO(156, 132, 255, 1),
  ];

  static LinearGradient buildScaffoldGradient() => const LinearGradient(
        colors: scaffoldGradientColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient buildPrimaryGradient({
    List<Color> colors = primaryGradientColors,
    Alignment begin = Alignment.centerLeft,
    Alignment end = Alignment.centerRight,
  }) =>
      LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      );

  static LinearGradient buildSecondaryGradient({
    List<Color> colors = secondaryGradientColors,
    Alignment begin = Alignment.centerLeft,
    Alignment end = Alignment.centerRight,
  }) =>
      LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      );

  static const Color textPrimary = Color(0xFF1F2933);
  static const Color textSecondary = Color(0xFF6B7280);
}

