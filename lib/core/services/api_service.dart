import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:novacart/core/models/product.dart';

const String kBaseUrl = 'https://fakestoreapi.com';

class ApiService {
  static final List<Map<String, dynamic>> _localOrderHistory = [];
  int _orderCounter = 0;
  // We no longer need _simulateDelay or _fakeProductsData

  // --- Products API: Fetch All ---
  Future<List<Product>> fetchAllProducts() async {
    final uri = Uri.parse('$kBaseUrl/products');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Successful response
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        // Handle error status codes
        throw Exception(
          'Failed to load products. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handle network errors
      throw Exception('Network error during product fetch: $e');
    }
  }

  // --- Products API: Fetch Details ---
  Future<Product> fetchProductDetails(int id) async {
    final uri = Uri.parse('$kBaseUrl/products/$id');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        return Product.fromJson(jsonBody);
      } else {
        throw Exception(
          'Failed to load product details for ID $id. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error during details fetch: $e');
    }
  }

  // --- Search API (Client-side filtering for simplicity, or API if supported) ---
  // The Fake Store API doesn't have a built-in search endpoint, so we fetch all
  // and filter locally (same logic as before, but with live data).
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    final products = await fetchAllProducts(); // Fetch all data first

    final lowerCaseQuery = query.toLowerCase();

    final results = products
        .where(
          (p) =>
              p.title.toLowerCase().contains(lowerCaseQuery) ||
              p.description.toLowerCase().contains(lowerCaseQuery),
        )
        .toList();

    return results;
  }

  // --- Cart/Checkout API (FIXED: Now stores local order history) ---
  Future<bool> checkoutCart(List<int> productIds, double totalAmount) async {
    // 1. Simulate API call success
    await Future.delayed(const Duration(seconds: 1));

    // 2. If successful, record the order locally
    _orderCounter++;
    _localOrderHistory.insert(0, {
      // Insert at the beginning to show newest first
      'orderId': '#NCART-$_orderCounter',
      'date': DateTime.now().toString().substring(0, 10), // Current date
      'total': totalAmount, // Use the real total amount
      'status': 'Processing',
      'items': productIds.length,
      // You could add 'productIds: productIds' here for detailed history
    });

    return true;
  }

  // --- Order History API (FIXED: Now returns local order history) ---
  Future<List<Map<String, dynamic>>> fetchMyOrders() async {
    // 1. Simulate delay for fetching
    await Future.delayed(const Duration(milliseconds: 500));

    // 2. Return the locally stored history instead of calling the Fake Store /carts endpoint
    return _localOrderHistory;
  }
}
