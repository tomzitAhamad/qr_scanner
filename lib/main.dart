import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_code_scanner/app/app.dart';
import 'package:qr_code_scanner/core/providers/navigation_provider.dart';
import 'package:qr_code_scanner/core/providers/scanner_provider.dart';
import 'package:qr_code_scanner/core/providers/history_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const QrScannerApp(),
    ),
  );
}
