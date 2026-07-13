import 'package:flutter/material.dart';

class ScannerFramePainter extends CustomPainter {
  final Color borderColor;
  final Color cornerColor;
  final double cornerLength;
  final double cornerWidth;
  final double borderRadius;

  ScannerFramePainter({
    required this.borderColor,
    required this.cornerColor,
    required this.cornerLength,
    required this.cornerWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rrect, borderPaint);

    final cornerPaint = Paint()
      ..color = cornerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round;

    final double len = cornerLength;
    final double rad = borderRadius;

    final topLeftPath = Path()
      ..moveTo(0, len)
      ..lineTo(0, rad)
      ..arcToPoint(Offset(rad, 0), radius: Radius.circular(rad))
      ..lineTo(len, 0);
    canvas.drawPath(topLeftPath, cornerPaint);

    final topRightPath = Path()
      ..moveTo(size.width - len, 0)
      ..lineTo(size.width - rad, 0)
      ..arcToPoint(Offset(size.width, rad), radius: Radius.circular(rad))
      ..lineTo(size.width, len);
    canvas.drawPath(topRightPath, cornerPaint);

    final bottomLeftPath = Path()
      ..moveTo(0, size.height - len)
      ..lineTo(0, size.height - rad)
      ..arcToPoint(
        Offset(rad, size.height),
        radius: Radius.circular(rad),
        clockwise: false,
      )
      ..lineTo(len, size.height);
    canvas.drawPath(bottomLeftPath, cornerPaint);

    final bottomRightPath = Path()
      ..moveTo(size.width - len, size.height)
      ..lineTo(size.width - rad, size.height)
      ..arcToPoint(
        Offset(size.width, size.height - rad),
        radius: Radius.circular(rad),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - len);
    canvas.drawPath(bottomRightPath, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
