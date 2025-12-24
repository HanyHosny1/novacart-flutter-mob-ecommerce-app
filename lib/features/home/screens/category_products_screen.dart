import 'package:flutter/material.dart';
import 'package:novacart/core/models/product.dart';
import 'package:novacart/core/services/api_service.dart';
import 'package:novacart/features/home/widgets/product_card.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryProductsScreen({required this.categoryName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName.toUpperCase())),
      body: FutureBuilder<List<Product>>(
        future: ApiService().fetchProductsByCategory(categoryName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ProductCard(product: products[i]),
          );
        },
      ),
    );
  }
}
