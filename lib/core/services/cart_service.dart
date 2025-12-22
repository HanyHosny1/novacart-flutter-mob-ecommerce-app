import 'package:flutter/material.dart';
import 'package:novacart/core/models/product.dart';
import 'package:novacart/core/models/cart_item.dart';
import 'package:novacart/core/services/api_service.dart';

class CartService with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalItemPrice);
  }

  void addItem(Product product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  // Helper method used by the + button in the UI
  void addSingleItem(Product product) {
    addItem(product);
  }

  // Helper method used by the - button in the UI
  void removeSingleItem(int productId) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == productId,
    );
    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        _items.removeAt(existingIndex);
      }
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int newQuantity) {
    final item = _items.firstWhere((item) => item.product.id == productId);
    if (newQuantity > 0) {
      item.quantity = newQuantity;
    } else {
      removeItem(productId);
    }
    notifyListeners();
  }

  // --- UPDATED CHECKOUT LOGIC ---
  Future<bool> checkout() async {
    if (_items.isEmpty) return false;

    try {
      // 1. Prepare the detailed order data
      final orderData = {
        'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
        'total': totalAmount,
        'date': DateTime.now().toLocal().toString().split(
          '.',
        )[0], // Cleaner date format
        'status': 'Processing',
        'products': _items
            .map(
              (cartItem) => {
                'quantity': cartItem.quantity,
                'product': {
                  'id': cartItem.product.id,
                  'title': cartItem.product.title,
                  'description': cartItem.product.description,
                  'price': cartItem.product.price,
                  'image': cartItem.product.image,
                },
              },
            )
            .toList(),
      };

      // 2. Call the API service to save this detailed order
      // We pass the orderData map so My Orders screen can read all details later
      final success = await _apiService.saveDetailedOrder(orderData);

      if (success) {
        // 3. Simulate a short delay for the "processing" feel
        await Future.delayed(const Duration(milliseconds: 500));

        // 4. Clear the cart and update UI
        _items.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Checkout Error: $e");
      return false;
    }
  }
}
