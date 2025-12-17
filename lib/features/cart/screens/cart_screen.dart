import 'package:flutter/material.dart';
import 'package:novacart/features/cart/screens/cart_item_tile.dart';
import 'package:provider/provider.dart';
import 'package:novacart/core/services/cart_service.dart';
import 'package:novacart/shared/theme/colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer rebuilds only when CartService notifies listeners
    return Consumer<CartService>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(title: Text('Your Cart (${cart.itemCount})')),
          body: cart.items.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty. Time to shop!',
                    style: TextStyle(fontSize: 18, color: kSubtleTextColor),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      // List of Cart Items
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, i) => CartItemTile(cart.items[i]),
                      ),
                    ),

                    // Checkout Summary Area (Sticky bottom container)
                    _buildCheckoutSummary(context, cart),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildCheckoutSummary(BuildContext context, CartService cart) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: kSurfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total Amount Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: kAccentColor),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleCheckout(context, cart),
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  // --- Checkout Button Handler with Timeout Message ---
  void _handleCheckout(BuildContext context, CartService cart) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final isDone = await cart.checkout();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          isDone
              ? '✅ Success! Order is done and moved to "My Orders" tab.'
              : '❌ Order Failed. Please try again.',
          style: const TextStyle(color: kSurfaceColor),
        ),
        backgroundColor: isDone ? kSuccessColor : kErrorColor,
        duration: const Duration(seconds: 3),
      ),
    );

    // Close the cart screen after successful checkout
    if (isDone) {
      // A small delay to let the user read the success message
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pop();
    }
  }
}
