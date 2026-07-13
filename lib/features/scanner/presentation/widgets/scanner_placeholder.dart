import 'package:flutter/material.dart';

class ScannerPlaceholder extends StatelessWidget {
  final double boxSize;

  const ScannerPlaceholder({super.key, required this.boxSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: boxSize,
      width: boxSize,
      child: const Center(
        child: Icon(Icons.qr_code_2, color: Colors.white24, size: 70),
      ),
    );
  }
}
