import 'package:flutter/material.dart';

class ScannerOutline extends StatelessWidget {
  const ScannerOutline({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 260,
        width: 260,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(34),
        ),
        child: Center(
          child: Icon(Icons.qr_code_2, color: Colors.white24, size: 80),
        ),
      ),
    );
  }
}
