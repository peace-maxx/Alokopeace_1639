import 'package:flutter/material.dart';

import 'create_sale.dart';
import 'customer_mngt_screen.dart';
import 'customization_screen.dart';
import 'home_screen.dart';
import 'iventory_screen.dart';
import 'login_screen.dart';
import 'offline_mode_screen.dart';
import 'payment_screen.dart';
import 'product_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'splash_screen.dart';

void main() {
  runApp(const POSRetailProApp());
}

class POSRetailProApp extends StatelessWidget {
  const POSRetailProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Retail Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/new_sale': (context) => const NewSaleScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/products': (context) => const ProductSelectionScreen(),
        '/payment': (context) => const PaymentMethodsScreen(),
        '/customers': (context) => const CustomerManagementScreen(),
        '/reports': (context) => const ReportsAnalyticsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/business_profile': (context) =>
            const BusinessProfileCustomizationScreen(),
        '/offline': (context) => const OfflineModeScreen(),
      },
    );
  }
}
