import 'package:flutter/material.dart';
import 'package:qr_code_scanner/features/home/presentation/pages/home_screen.dart';
import 'package:qr_code_scanner/features/splash/presentation/pages/splash_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget widget = SizedBox();
    switch (settings.name) {
      case "/":
        widget = SplashScreen();
        break;
      case "/home":
        widget = HomeScreen();
        break;
      default:
        widget = SizedBox();
    }
    return MaterialPageRoute(builder: (context) => widget);
  }
}
