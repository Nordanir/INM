import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';

double smallFontSize(BuildContext context) =>
    MediaQuery.of(context).size.width > 1400 ? 16 : 12;
double normalFontSize(BuildContext context) =>
    MediaQuery.of(context).size.width > 1400 ? 20 : 16;
double largeFontSize(BuildContext context) =>
    MediaQuery.of(context).size.width > 1400 ? 24 : 20;
double largeTitleFontSize(BuildContext context) =>
    MediaQuery.of(context).size.width > 1400 ? 16 : 14;

const FontWeight normalFontWeight = FontWeight.w600;
const FontWeight emphasizedFontWeight = FontWeight.w900;

TextTheme textTheme = TextTheme(
  bodyLarge: defaultTextStyle.copyWith(),
  bodyMedium: defaultTextStyle,
  bodySmall: defaultTextStyle.copyWith(),
  titleMedium: defaultTextStyle.copyWith(fontWeight: emphasizedFontWeight),
  titleLarge: defaultTextStyle.copyWith(fontWeight: emphasizedFontWeight),
);

TextStyle defaultTextStyle = TextStyle(
  fontWeight: emphasizedFontWeight,
  color: black,
  fontSize: 16,
  fontFamily: "Inconsolata",
);

ThemeData theme = ThemeData(
  textTheme: textTheme,
  hintColor: black.withValues(alpha: 0.6),
);
