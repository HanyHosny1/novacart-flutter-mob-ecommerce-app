import 'product.dart'; // Import the Product model

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Convenience getter for the total price of this item
  double get totalItemPrice => product.price * quantity;
}
