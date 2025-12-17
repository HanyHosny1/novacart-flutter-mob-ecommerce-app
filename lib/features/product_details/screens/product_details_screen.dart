import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novacart/core/models/product.dart';
import 'package:novacart/core/services/api_service.dart';
import 'package:novacart/core/services/cart_service.dart';
import 'package:novacart/shared/theme/colors.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    // ... (unchanged build method)
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: apiService.fetchProductDetails(
          productId,
        ), // Fetch single product data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Use a visual loading indicator
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading details: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Product not found.'));
          }

          final product = snapshot.data!;
          return _buildDetailsBody(context, product);
        },
      ),
    );
  }

  // --- UI Builder Function ---
  Widget _buildDetailsBody(BuildContext context, Product product) {
    // Safely extract rating values
    final double ratingValue = product.rating['rate']?.toDouble() ?? 0.0;
    final int reviewCount = product.rating['count'] ?? 0;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. Image Area (Using NetworkImage for live API)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    // Use a NetworkImage to load the actual product image from the API
                    image: DecorationImage(
                      image: NetworkImage(product.image),
                      fit: BoxFit.contain, // Show the whole image
                    ),
                  ),
                  // Removed the placeholder Text
                ),
                const SizedBox(height: 20),

                // 2. Name and Price
                Text(
                  product
                      .title, // FIX: Use product.title instead of product.name
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(color: kAccentColor),
                ),
                const SizedBox(height: 15),

                // 3. Rating Row
                Row(
                  children: [
                    const Icon(Icons.star, color: kWarningColor, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      // FIX: Access the 'rate' value and call toStringAsFixed(1)
                      '${ratingValue.toStringAsFixed(1)} rating',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '($reviewCount reviews)', // Use the actual count from the API
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const Divider(height: 30),

                // 4. Description
                Text('Details', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 15),
                // Removed the placeholder text using product.description twice
              ],
            ),
          ),
        ),

        // 5. Sticky Bottom Bar
        _buildBottomBar(context, product),
      ],
    );
  }

  // --- Bottom Bar with Add to Cart Button ---
  Widget _buildBottomBar(BuildContext context, Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: double.infinity,
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
      child: SafeArea(
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_shopping_cart, color: kSurfaceColor),
            label: const Text('Add to Cart'),
            onPressed: () => _handleAddToCart(context, product),
          ),
        ),
      ),
    );
  }

  // --- Add to Cart Handler ---
  void _handleAddToCart(BuildContext context, Product product) {
    // Access CartService using Provider and add the product
    Provider.of<CartService>(context, listen: false).addItem(product);

    // Show the success message (Snack Bar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          // FIX: Use product.title instead of product.name
          '🛒 Added ${product.title} to cart!',
          style: const TextStyle(color: kSurfaceColor),
        ),
        backgroundColor: kPrimaryColor,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}
