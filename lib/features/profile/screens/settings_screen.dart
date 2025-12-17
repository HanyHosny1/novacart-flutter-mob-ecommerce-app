import 'package:flutter/material.dart';
import 'package:novacart/shared/theme/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:novacart/features/profile/screens/edit_profile_screen.dart'; // NEW
import 'package:novacart/features/profile/screens/change_password_screen.dart'; // NEW
import 'package:novacart/features/profile/screens/payment_methods_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Placeholder User Data (In a real app, this would come from a user model/provider)
  final String userName = 'Hany Hosny';
  final String userEmail = 'hany.hosny@test.com';

  @override
  Widget build(BuildContext context) {
    // Listen to the themeProvider to trigger rebuilds for the Switch state
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode =
        themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildProfileCard(context),
          ),

          const SizedBox(height: 16),

          // --- ACCOUNT SECTION ---
          _buildHeader(context, 'ACCOUNT'),

          // Edit Profile
          _buildSettingsTile(
            context,
            'Edit Profile Information',
            Icons.person_outline,
            () {
              // NAVIGATE to Edit Profile
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => EditProfileScreen(
                    userName: userName, // Pass data here
                    userEmail: userEmail, // Pass data here
                  ),
                ),
              );
            },
          ),
          // Change Password/Security
          _buildSettingsTile(context, 'Change Password', Icons.security, () {
            // NAVIGATE to Change Password
            Navigator.of(context).pushNamed('/change-password');
          }),
          // Payment Methods
          _buildSettingsTile(context, 'Payment Methods', Icons.credit_card, () {
            // NAVIGATE to Payment Methods
            Navigator.of(context).pushNamed('/payment-methods');
          }),
          // Saved Addresses
          _buildSettingsTile(
            context,
            'Saved Addresses',
            Icons.location_on_outlined,
            () {},
          ),

          const SizedBox(height: 16),

          // --- GENERAL SECTION ---
          _buildHeader(context, 'GENERAL'),

          // Notifications
          _buildSettingsTile(
            context,
            'Notifications',
            Icons.notifications_none,
            () {},
          ),

          // Dark Mode Toggle (Consolidated and using the appropriate icon)
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Dark Mode'),
            trailing: Switch(
              // Using Provider.of without listen: false in build, so rebuilds happen when theme changes
              value: isDarkMode,
              onChanged: (bool newValue) {
                // We use Provider.of<T>(context, listen: false) for function calls
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme(newValue);
              },
            ),
            onTap: () {
              // Allows tapping the tile itself to toggle the switch
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme(!isDarkMode);
            },
          ),
        ],
      ),
    );
  }

  // Helper Widget for Section Headers
  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const Divider(height: 10),
        ],
      ),
    );
  }

  // Helper Widget: Profile Card
  Widget _buildProfileCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            // User Avatar
            const CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/images/employee.jpg'),
            ),
            const SizedBox(width: 20),

            // User Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Reusable Settings ListTile
  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
