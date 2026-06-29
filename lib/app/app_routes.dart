import 'package:flutter/material.dart';

import '../features/scanner/presentation/pages/scanner_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget widget = SizedBox();
    switch (settings.name) {
      case "/":
        widget = ScannerPage();
        break;

      default:
        widget = SizedBox();
    }
    return MaterialPageRoute(builder: (context) => widget);
  }
}
