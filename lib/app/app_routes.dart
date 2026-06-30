import 'package:flutter/material.dart';

import '../features/create_qr/presentation/pages/create_qr_page.dart';
import '../features/favorites/presentation/pages/favorite_page.dart';
import '../features/history/presentation/pages/history_page.dart';
import '../features/scanner/presentation/pages/scanner_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/my_qr/presentation/pages/my_qr_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget widget = SizedBox();
    switch (settings.name) {
      case "/":
        widget = ScannerPage();
        break;

      case "/favorite":
        widget = FavoritePage();
        break;

      case "/history":
        widget = HistoryPage();
        break;

      case "/my_qr":
        widget = MyQrPage();
        break;

      case "/create_qr":
        widget = CreateQrPage();
        break;

      case "/settings":
        widget = SettingsPage();
        break;

      default:
        widget = ScannerPage();
    }
    return MaterialPageRoute(builder: (context) => widget);
  }
}
