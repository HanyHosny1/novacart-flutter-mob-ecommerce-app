import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novacart/core/models/cart_item.dart';
import 'package:novacart/core/services/cart_service.dart';
import 'package:novacart/shared/theme/colors.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile(this.cartItem, {super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context, listen: false);

    return Dismissible(
      key: ValueKey(cartItem.product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(cartItem.product.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // FIX: Use cartItem.product.title
            content: Text('${cartItem.product.title} removed from cart.'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      // ... (background widget is correct)
      child: Card(
        // ... (Card styling is correct)
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              // ... (CircleAvatar content is correct)
              child: Text(
                '\$${cartItem.product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              cartItem.product.title, // FIX: Use cartItem.product.title
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              // ... (Subtitle is correct)
              'Total: \$${cartItem.totalItemPrice.toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: kSubtleTextColor),
            ),
            // ... (Trailing Row with quantity controls is correct)
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Icon(icon, size: 18, color: kTextColor),
      ),
    );
  }
}
