import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/scanner_app_bar.dart';
import '../widgets/scanner_overlay.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.black),

          SafeArea(child: ScannerAppBar()),
          ScannerOutline(),
        ],
      ),
    );
  }
}
