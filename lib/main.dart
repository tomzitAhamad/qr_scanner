import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/app/app.dart';
import 'package:qr_code_scanner/core/providers/navigation_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: const QrScannerApp(),
    ),
  );
}
