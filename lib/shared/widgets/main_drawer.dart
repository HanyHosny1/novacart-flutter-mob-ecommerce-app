import 'package:flutter/material.dart';
import 'package:novacart/shared/theme/colors.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 90,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            color: const Color.fromARGB(255, 78, 44, 138),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'NovaCart',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: kSurfaceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/novacart_logo.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Home
          _buildListTile(context, 'Home', Icons.home_outlined, () {
            // Using pushReplacementNamed to prevent accumulating screens
            Navigator.of(context).pushReplacementNamed('/');
          }),

          // Cart (NEW)
          _buildListTile(context, 'Cart', Icons.shopping_cart_outlined, () {
            Navigator.of(context).pop(); // Close drawer
            Navigator.of(context).pushNamed('/cart');
          }),

          // Wishlist (NEW)
          _buildListTile(context, 'My Wishlist', Icons.favorite_border, () {
            Navigator.of(context).pop(); // Close drawer
            Navigator.of(
              context,
            ).pushNamed('/wishlist'); // Assuming you have this route
          }),

          // My Orders
          _buildListTile(context, 'My Orders', Icons.receipt_long_outlined, () {
            Navigator.of(context).pop(); // Close the drawer first
            Navigator.of(
              context,
            ).pushNamed('/my-orders'); // Assuming you have this route
          }),

          const Divider(),

          // Settings (UPDATED to navigate)
          _buildListTile(context, 'Settings', Icons.settings_outlined, () {
            // Use pushReplacementNamed to navigate to a primary destination
            Navigator.of(context).pushNamed('/settings');
          }),

          // Logout (Optional but recommended)
          _buildListTile(context, 'Logout', Icons.logout, () {
            // Implement logout logic here
            Navigator.of(context).pop(); // Close the drawer
            // Navigator.of(context).pushReplacementNamed('/auth-screen');
          }),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback tapHandler,
  ) {
    // NOTE: The implementation of this method is unchanged.
    return ListTile(
      leading: Icon(icon, size: 26, color: kSubtleTextColor),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
      ),
      onTap: tapHandler,
    );
  }
}
