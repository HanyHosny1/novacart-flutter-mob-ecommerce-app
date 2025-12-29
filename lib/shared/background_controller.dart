import 'package:flutter/material.dart';

class BackgroundController extends ChangeNotifier {
  Offset blob1Pos = const Offset(0.1, 0.1);
  Offset blob2Pos = const Offset(0.8, 0.8);

  void updatePosition(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        blob1Pos = const Offset(0.05, 0.1); // Top Left
        blob2Pos = const Offset(0.6, 0.7); // Bottom Right
        break;
      case '/product-details':
        blob1Pos = const Offset(0.5, -0.1); // Top Center
        blob2Pos = const Offset(0.1, 0.8); // Bottom Left
        break;
      case '/cart':
        blob1Pos = const Offset(0.8, 0.2); // Top Right
        blob2Pos = const Offset(0.2, 0.5); // Center Left
        break;
      default:
        blob1Pos = const Offset(0.3, 0.3);
        blob2Pos = const Offset(0.5, 0.8);
    }
    notifyListeners();
  }
}
