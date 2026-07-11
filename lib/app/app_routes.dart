import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/features/create_qr/presentation/pages/create_qr_form_page.dart';

import '../features/create_qr/presentation/pages/create_qr_page.dart';
import '../features/favorites/presentation/pages/favorite_page.dart';
import '../features/history/presentation/pages/history_page.dart';
import '../features/scanner/presentation/pages/scanner_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/my_qr/presentation/pages/my_qr_page.dart';

class ExitConfirmWrapper extends StatelessWidget {
  final Widget child;
  const ExitConfirmWrapper({super.key, required this.child});

  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.exit_to_app, color: Color(0xFF2563EB), size: 24),
            SizedBox(width: 10),
            Text(
              'Exit App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to leave the app?',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'No',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Yes, Exit',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitDialog(context);
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget widget = const SizedBox();
    switch (settings.name) {
      case "/":
        widget = const ScannerPage();
        break;

      case "/favorite":
        widget = const FavoritePage();
        break;

      case "/history":
        widget = const HistoryPage();
        break;

      case "/my_qr":
        widget = const MyQrPage();
        break;

      case "/create_qr":
        widget = const CreateQrPage();
        break;

      case "/create_qr/form":
        final args = settings.arguments as Map<String, dynamic>?;
        widget = CreateQrFormPage(
          type: args?['type'] ?? '',
          title: args?['title'] ?? '',
        );
        break;

      case "/settings":
        widget = const SettingsPage();
        break;

      default:
        widget = const ScannerPage();
    }

    return MaterialPageRoute(
      builder: (context) => ExitConfirmWrapper(child: widget),
    );
  }
}
