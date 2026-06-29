import 'package:flutter/material.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';

import '../widgets/scanner_app_bar.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [SafeArea(child: ScannerAppBar())]),
    );
  }
}
