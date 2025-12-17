import 'package:flutter/material.dart';
import 'package:novacart/core/models/product.dart';
import 'package:novacart/core/services/api_service.dart';
import 'package:novacart/features/home/widgets/product_card.dart';
import 'package:novacart/shared/theme/colors.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final ApiService apiService = ApiService();

  // 1. Build the Leading Icon (usually a back button)
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close the search view
      },
    );
  }

  // 2. Build the Actions (e.g., clear text button)
  @override
  List<Widget> buildActions(BuildContext context) {
    // RETURN TYPE MUST BE List<Widget>
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the current search query
          showSuggestions(context);
        },
      ),
    ];
  }

  // 3. Build the Search Results
  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Enter a search term to find products.'));
    }

    return FutureBuilder<List<Product>>(
      future: apiService.searchProducts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No results found for "$query".',
              style: const TextStyle(color: kSubtleTextColor),
            ),
          );
        }

        final results = snapshot.data!;
        // Display results using the same modern Grid View as the Home Screen
        return GridView.builder(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: results.length,
          itemBuilder: (ctx, i) {
            return ProductCard(product: results[i]); // Reusing the ProductCard
          },
        );
      },
    );
  }

  // 4. Build Suggestions (displayed when the user hasn't pressed Enter/Search)
  @override
  Widget buildSuggestions(BuildContext context) {
    // For simplicity, we won't show live suggestions from the API.
    // Instead, we can show recent search terms or trending categories.
    final List<String> recentSearches = [
      'Sneakers',
      'Smartwatch',
      'Backpack',
      'New Arrivals',
    ];

    final filteredSuggestions = recentSearches.where((term) {
      return term.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = filteredSuggestions[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context); // Run the search immediately on tap
          },
        );
      },
    );
  }
}
