import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/core/providers/scanner_provider.dart';

class ScannerAppBar extends StatelessWidget {
  const ScannerAppBar({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIcon(
            icon: Icons.menu,
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          if (title != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Row(
            children: [
              _circleIcon(
                icon: Icons.image_outlined,
                onTap: () {
                  context.read<ScannerProvider>().scanImage(context);
                },
              ),
              const SizedBox(width: 12),
              Consumer<ScannerProvider>(
                builder: (context, scannerProvider, child) {
                  return _circleIcon(
                    icon: scannerProvider.isFlashOn
                        ? Icons.flash_on
                        : Icons.flash_off,
                    onTap: () {
                      scannerProvider.toggleFlash();
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
    Color? bgColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: bgColor ?? const Color(0x2EFFFFFF),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
