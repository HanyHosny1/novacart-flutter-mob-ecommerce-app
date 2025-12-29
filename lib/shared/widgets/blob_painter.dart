import 'package:flutter/material.dart';

class BlobPainter extends CustomPainter {
  final Color color;
  // Reduced opacity to 0.15 for a subtler background feel
  BlobPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
          .withOpacity(0.15) // Slightly softer opacity
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        60,
      ); // Increased blur for "blob" effect

    Path path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.5);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width * 0.5,
      size.height,
    );
    path.quadraticBezierTo(0, size.height, 0, size.height * 0.2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
