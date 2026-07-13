import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/scanner_provider.dart';
import 'scanner_frame_painter.dart';
import 'scanner_placeholder.dart';
import 'scanner_laser_line.dart';

class ScannerOutline extends StatefulWidget {
  const ScannerOutline({super.key});

  @override
  State<ScannerOutline> createState() => _ScannerOutlineState();
}

class _ScannerOutlineState extends State<ScannerOutline>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scannerProvider = context.watch<ScannerProvider>();
    final isScanning = !scannerProvider.isScanned;

    if (isScanning && !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    } else if (!isScanning && _animationController.isAnimating) {
      _animationController.stop();
    }

    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    const double boxSize = 220.0;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: const Size(boxSize, boxSize),
            painter: ScannerFramePainter(
              borderColor: Colors.white.withOpacity(0.3),
              cornerColor: primaryColor,
              cornerLength: 24.0,
              cornerWidth: 4.0,
              borderRadius: 34.0,
            ),
          ),
          const ScannerPlaceholder(boxSize: boxSize),
          if (isScanning)
            ScannerLaserLine(
              animation: _animationController,
              boxSize: boxSize,
              color: primaryColor,
            ),
        ],
      ),
    );
  }
}
