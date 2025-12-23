import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novacart/core/services/wishlist_service.dart';
import 'package:novacart/core/services/cart_service.dart';
import 'package:novacart/shared/theme/colors.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: wishlist.items.isEmpty
          ? const Center(child: Text('Your wishlist is empty!'))
          : ListView.builder(
              itemCount: wishlist.items.length,
              itemBuilder: (ctx, i) {
                final product = wishlist.items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    onTap: () {
                      // Navigate to Product Details
                      Navigator.pushNamed(
                        context,
                        '/product-details',
                        arguments: product,
                      );
                    },
                    leading: Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('\$${product.price}'),
                    trailing: IconButton(
                      // YOUR CUSTOM ADD TO CART ICON
                      icon: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: kPrimaryColor, // Purple color from your image
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<CartService>(
                          context,
                          listen: false,
                        ).addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to Cart!')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
