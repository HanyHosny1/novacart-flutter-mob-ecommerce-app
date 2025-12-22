import 'package:flutter/material.dart';
import 'package:novacart/shared/theme/colors.dart';
import 'package:novacart/core/services/api_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final ApiService apiService = ApiService();

  void _showDeleteConfirmation(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Order'),
        content: const Text(
          'Are you sure you want to remove this order from your history?',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: kErrorColor)),
            onPressed: () async {
              // 1. Actually delete from the service
              await apiService.deleteOrder(orderId);

              // 2. Close dialog
              if (!mounted) return;
              Navigator.of(ctx).pop();

              // 3. Refresh the UI
              setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order removed successfully')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiService.fetchMyOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (ctx, i) => OrderTile(
              order: orders[i],
              onDelete: () => _showDeleteConfirmation(
                context,
                orders[i]['orderId'].toString(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onDelete;

  const OrderTile({required this.order, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    final products = order['products'] as List<dynamic>? ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          'Order #${order['orderId']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Total: \$${order['total'].toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: kErrorColor,
          ), // RED BASKET/DELETE ICON
          onPressed: onDelete,
        ),
        children: [
          const Divider(),
          ...products.map((item) {
            // Fetching nested product details
            final p = item['product'];
            return ListTile(
              leading: Image.network(
                p['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                p['title'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p['description'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11),
                  ),
                  Text('Qty: ${item['quantity']} | Price: \$${p['price']}'),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
