import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

abstract class SubApp {
  String get homePage;

  String? get label;

  String? get appIcon;

  int? get subsystemId;

  String get routePrefix;

  ThemeData get lightTheme;

  ThemeData get darkTheme;

  List<RouteBase> get routes;

  static SystemUiOverlayStyle createSystemOverlayStyle(
    ColorScheme colorScheme,
  ) =>
      SystemUiOverlayStyle(
        statusBarColor: colorScheme.primary,
        statusBarIconBrightness: colorScheme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: colorScheme.brightness,
        systemNavigationBarColor: colorScheme.surface,
        systemNavigationBarIconBrightness:
            colorScheme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarDividerColor: colorScheme.onSurface,
      );
}
