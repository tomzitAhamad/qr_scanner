import 'package:flutter/material.dart';
import 'package:qr_code_scanner/app/app_routes.dart';

class QrScannerApp extends StatelessWidget {
  const QrScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Qr Scanner",
      initialRoute: "/",
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
