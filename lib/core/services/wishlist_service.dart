import 'package:flutter/material.dart';
import 'package:novacart/core/models/product.dart';

class WishlistService with ChangeNotifier {
  final List<Product> _wishlistItems = [];

  List<Product> get items => [..._wishlistItems];

  bool isFavorite(int productId) {
    return _wishlistItems.any((p) => p.id == productId);
  }

  void toggleWishlist(Product product) {
    final isExist = isFavorite(product.id);
    if (isExist) {
      _wishlistItems.removeWhere((p) => p.id == product.id);
    } else {
      _wishlistItems.add(product);
    }
    notifyListeners();
  }
}
