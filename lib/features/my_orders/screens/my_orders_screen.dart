import 'package:flutter/material.dart';
import 'package:novacart/shared/theme/colors.dart';
import 'package:novacart/core/services/api_service.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      // The future builder expects a List of Maps, which is what apiService.fetchMyOrders returns.
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiService.fetchMyOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading orders: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'You have no past orders.',
                style: TextStyle(fontSize: 18, color: kSubtleTextColor),
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: orders.length,
            itemBuilder: (ctx, i) => OrderTile(order: orders[i]),
          );
        },
      ),
    );
  }
}

// Widget to display a single order
class OrderTile extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderTile({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    // We safely retrieve the data fields from the map.
    // The keys used here ('orderId', 'date', 'total', 'status', 'items')
    // must match the keys created in the ApiService.fetchMyOrders() method.
    final orderId = order['orderId'] ?? 'N/A';
    final date = order['date'] ?? 'N/A';
    final status = order['status'] ?? 'Processing';
    final total = order['total']?.toStringAsFixed(2) ?? '0.00';
    final itemsCount = order['items'] ?? 0;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(15),
        title: Text(
          'Order ID: $orderId', // Use the correctly formatted variable
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text('Date: $date | Status: $status'), // Use the variables
        trailing: Text(
          '\$$total', // Use the correctly formatted variable
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: kPrimaryColor),
        ),

        // Order details section
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text(
                  'Items Purchased: $itemsCount unique item(s)', // Display the count
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  // Static placeholder for address since the API doesn't provide it easily
                  'Shipping Address: 123 Nova Lane, Stellar City',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // Note: For a true order history, you would need another API call
                // here to fetch the product details for each item ID listed in cart['products'].
              ],
            ),
          ),
        ],
      ),
    );
  }
}
