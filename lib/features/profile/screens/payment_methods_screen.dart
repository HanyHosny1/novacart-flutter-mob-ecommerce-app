import 'package:flutter/material.dart';
import 'package:novacart/features/profile/screens/add_payment_method_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: ListView(
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Visa ending in 4242'),
            subtitle: Text('Default Card - Expires 12/26'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.payment),
            title: Text('Mastercard ending in 1001'),
            subtitle: Text('Expires 05/25'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Add New Payment Method'),
            onTap: () {
              Navigator.of(context).pushNamed('/add-payment');
            },
          ),
        ],
      ),
    );
  }
}
