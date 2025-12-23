import 'package:flutter/material.dart';
import 'package:novacart/core/models/product.dart';
import 'package:novacart/core/services/cart_service.dart';
import 'package:novacart/core/services/wishlist_service.dart'; // IMPORT THIS
import 'package:novacart/shared/theme/colors.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed('/product-details', arguments: product.id);
      },
      child: Card(
        clipBehavior:
            Clip.antiAlias, // Ensures child widgets don't bleed out of corners
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- THE STACK STARTS HERE ---
              Expanded(
                child: Stack(
                  children: [
                    // 1. The Product Image
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: NetworkImage(product.image),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // 2. The Heart Icon Positioned on Top Right
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Consumer<WishlistService>(
                        builder: (context, wishlist, child) {
                          final isFav = wishlist.isFavorite(product.id);
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                wishlist.toggleWishlist(product);
                                if (!isFav) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to Wishlist!'),
                                      duration: Duration(milliseconds: 800),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // --- THE STACK ENDS HERE ---
              const SizedBox(height: 8),

              // Product Name
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 4),

              // Price and Add to Cart Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: kAccentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_shopping_cart, size: 20),
                      color: kSurfaceColor,
                      onPressed: () {
                        Provider.of<CartService>(
                          context,
                          listen: false,
                        ).addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart!'),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
