import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intentWithData(String routeName, Object args) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: args);
  }

  static back() => navigatorKey.currentState?.pop();
}
