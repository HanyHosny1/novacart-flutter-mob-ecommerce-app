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
      background: Container(
        color: kErrorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        cart.removeItem(cartItem.product.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // 1. PRODUCT PHOTO
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cartItem.product.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 70),
                ),
              ),
              const SizedBox(width: 15),
              // 2. PRODUCT DETAILS (Name, Description, Price)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      cartItem.product.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: kSubtleTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${cartItem.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // 3. QUANTITY CONTROLS
              Column(
                children: [
                  _buildQuantityButton(
                    icon: Icons.add,
                    onPressed: () => cart.addSingleItem(cartItem.product),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('${cartItem.quantity}'),
                  ),
                  _buildQuantityButton(
                    icon: Icons.remove,
                    onPressed: () => cart.removeSingleItem(cartItem.product.id),
                  ),
                ],
              ),
            ],
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
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(onTap: onPressed, child: Icon(icon, size: 16)),
    );
  }
}
