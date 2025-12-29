import 'package:flutter/material.dart';
import '../background_controller.dart';
import 'blob_painter.dart';

class AnimatedBlobBackground extends StatelessWidget {
  final Widget child;
  final BackgroundController controller;

  const AnimatedBlobBackground({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Custom Colors based on "Light Grey & Blue" scheme
    const lightGreyBlue = Color(0xFFB7C9E2);
    const deepBlueGrey = Color.fromARGB(
      255,
      50,
      70,
      170,
    ); // Deeper Blue Grey [#6699CC]

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return Stack(
                children: [
                  // Blob 1: Light Grey-Blue
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOutSine,
                    top: controller.blob1Pos.dy * size.height,
                    left: controller.blob1Pos.dx * size.width,
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: BlobPainter(color: lightGreyBlue),
                    ),
                  ),
                  // Blob 2: Deeper Blue
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeInOutSine,
                    top: controller.blob2Pos.dy * size.height,
                    left: controller.blob2Pos.dx * size.width,
                    child: CustomPaint(
                      size: const Size(450, 400),
                      painter: BlobPainter(color: deepBlueGrey),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
