import 'package:flutter/material.dart';
import 'package:novacart/features/my_orders/screens/my_orders_screen.dart';
import 'package:novacart/features/profile/screens/add_payment_method_screen.dart';
import 'package:novacart/features/profile/screens/change_password_screen.dart';
import 'package:novacart/features/profile/screens/edit_profile_screen.dart';
import 'package:novacart/features/profile/screens/payment_methods_screen.dart';
import 'package:novacart/features/profile/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'core/services/cart_service.dart';
import 'features/home/screens/home_screen.dart';
import 'features/splash/splash_screen.dart';
import 'shared/theme/app_theme.dart';
import 'features/cart/screens/cart_screen.dart';
import 'features/product_details/screens/product_details_screen.dart';
import 'package:novacart/shared/theme/providers/theme_provider.dart';
import 'package:novacart/shared/theme/app_theme.dart';

void main() {
  runApp(
    // FIX: Use MultiProvider to register ALL necessary providers at the top level
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartService()),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ), // ADDED ThemeProvider
      ],
      child: const NovaCartApp(),
    ),
  );
}

class NovaCartApp extends StatelessWidget {
  const NovaCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Read the ThemeProvider here to control the themeMode property of MaterialApp
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'NovaCart',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode, // ADDED themeMode control
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/my-orders': (context) => const MyOrdersScreen(),
        '/settings': (ctx) => const SettingsScreen(),
        // '/edit-profile': (ctx) => const EditProfileScreen(),
        '/change-password': (ctx) => const ChangePasswordScreen(),
        '/payment-methods': (ctx) => const PaymentMethodsScreen(),
        '/add-payment': (ctx) => const AddPaymentMethodScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product-details') {
          final productId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (ctx) {
              return ProductDetailsScreen(productId: productId);
            },
          );
        }
        // Handle other routes or return null
        return null;
      },
    );
  }
}
