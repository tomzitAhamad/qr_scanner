import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/features/scanner/presentation/widgets/qr_camera_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/navigation_provider.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../widgets/scanner_app_bar.dart';
import '../widgets/scanner_overlay.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.black,
          body: Stack(
            children: [
              QrCameraView(),
              ScannerOutline(),

              SafeArea(child: ScannerAppBar()),

              if (provider.isDrawerOpen)
                Row(
                  children: [
                    const AppDrawer(),

                    Expanded(
                      child: GestureDetector(
                        onTap: provider.closeDrawer,
                        child: Container(color: Colors.black45),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
