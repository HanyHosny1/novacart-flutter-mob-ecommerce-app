import 'package:flutter/material.dart';
import 'package:novacart/core/models/product.dart';
import 'package:novacart/core/services/cart_service.dart';
import 'package:novacart/shared/theme/colors.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ... (Navigation logic is correct)
        Navigator.of(
          context,
        ).pushNamed('/product-details', arguments: product.id);
      },
      child: Card(
        // ... (Styling is correct)
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Product Image (Placeholder - Update to use NetworkImage for live data)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(12.0),
                    // NEW: Use NetworkImage to load the actual image URL
                    image: DecorationImage(
                      image: NetworkImage(product.image),
                      fit: BoxFit.contain,
                    ),
                  ),
                  // REMOVE: The Center/Text placeholder block, as we are now using the image
                ),
              ),
              const SizedBox(height: 8),

              // Product Name
              Text(
                product.title, // FIX: Use product.title
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              // Price and Action Row
              const SizedBox(height: 4),
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

                  // Add to Cart Button (Icon)
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_shopping_cart, size: 20),
                      color: kSurfaceColor,
                      onPressed: () {
                        // Use Provider to access CartService and add the product
                        Provider.of<CartService>(
                          context,
                          listen: false,
                        ).addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.title} added to cart!',
                            ), // FIX: Use product.title
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
