import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';

const Color darkPrimaryColor = Color(0xFF000000);
const Color darkSecondaryColor = Color(0xff64ffda);

LiveOptions globalOptions = const LiveOptions(
  delay: Duration.zero,
  showItemInterval: Duration(milliseconds: 100),
  showItemDuration: Duration(milliseconds: 250),
  visibleFraction: 0.025,
  reAnimateOnVisibility: false,
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
