import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:novacart/core/models/product.dart';

const String kBaseUrl = 'https://fakestoreapi.com';

class ApiService {
  static final List<Map<String, dynamic>> _localOrderHistory = [];
  int _orderCounter = 0;

  static final List<Map<String, dynamic>> _orders = [];
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

  // This is called by CartService during checkout
  Future<bool> saveDetailedOrder(Map<String, dynamic> orderData) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Save the order to our memory list
      _orders.insert(
        0,
        orderData,
      ); // insert(0, ...) puts newest orders at the top

      return true;
    } catch (e) {
      return false;
    }
  }

  // This is called by MyOrdersScreen to show the list
  Future<List<Map<String, dynamic>>> fetchMyOrders() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _orders;
  }

  // This implements the delete logic for the Red Basket icon
  Future<void> deleteOrder(String orderId) async {
    _orders.removeWhere((order) => order['orderId'].toString() == orderId);
  }

  Future<List<String>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products/categories'),
    );
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String categoryName) async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products/category/$categoryName'),
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products for $categoryName');
    }
  }
}
