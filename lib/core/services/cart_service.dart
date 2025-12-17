import 'package:flutter/material.dart';
import 'package:novacart/core/models/product.dart';
import 'package:novacart/core/models/cart_item.dart';
import 'package:novacart/core/services/api_service.dart';

class CartService with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<CartItem> _items = [];

  // Public accessor for the cart items
  List<CartItem> get items => _items;

  // Convenience getter for the total number of items in the cart
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Convenience getter for the total price of all items
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalItemPrice);
  }

  // --- Core Logic ---

  void addItem(Product product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // If item already exists, increase quantity
      _items[existingIndex].quantity++;
    } else {
      // If item is new, add it
      _items.add(CartItem(product: product, quantity: 1));
    }

    // Notify all listeners (widgets) to rebuild
    notifyListeners();
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
      // If quantity is zero or less, remove the item
      removeItem(productId);
    }
    notifyListeners();
  }

  // --- Checkout Logic ---

  // Placeholder for moving order to 'My Orders'
  Future<bool> checkout() async {
    final productIds = _items.map((item) => item.product.id).toList();
    final currentTotal = totalAmount; // Get the calculated total

    // 1. Simulate API call for checkout, passing the total amount
    final success = await _apiService.checkoutCart(
      productIds,
      currentTotal,
    ); // PASS TOTAL HERE

    if (success) {
      // 2. Simulate "time out message that order is done"
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. Order is done, clear the cart
      _items.clear();

      notifyListeners();
      return true;
    }
    return false;
  }
}
