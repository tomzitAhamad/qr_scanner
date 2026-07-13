import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_code_scanner/app/app.dart';
import 'package:qr_code_scanner/core/providers/navigation_provider.dart';
import 'package:qr_code_scanner/core/providers/scanner_provider.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';
import 'package:qr_code_scanner/core/providers/favorite_provider.dart';
import 'package:qr_code_scanner/core/providers/my_qr_provider.dart';
import 'package:qr_code_scanner/core/providers/create_qr_provider.dart';
import 'package:qr_code_scanner/core/providers/settings_provider.dart';
import 'package:qr_code_scanner/core/providers/responsive_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsProvider = await SettingsProvider.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => MyQrProvider()),
        ChangeNotifierProvider(create: (_) => CreateQrProvider()),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => ResponsiveProvider()),
      ],
      child: const QrScannerApp(),
    ),
  );
}
