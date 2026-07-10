import 'package:flutter/material.dart';
import 'package:qr_code_scanner/features/scanner/presentation/widgets/qr_camera_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../widgets/scanner_app_bar.dart';
import '../widgets/scanner_overlay.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          QrCameraView(),
          ScannerOutline(),
          SafeArea(child: ScannerAppBar()),
        ],
      ),
    );
  }
}

