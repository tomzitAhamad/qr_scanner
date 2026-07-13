import 'package:flutter/material.dart';

class ScannerLaserLine extends StatelessWidget {
  final Animation<double> animation;
  final double boxSize;
  final Color color;

  const ScannerLaserLine({
    super.key,
    required this.animation,
    required this.boxSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                top: boxSize * animation.value,
                left: 12,
                right: 12,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.6),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.1),
                        color,
                        color,
                        color.withOpacity(0.1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
