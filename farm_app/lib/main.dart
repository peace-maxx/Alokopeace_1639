import 'package:flutter/material.dart';

import 'flock_screen.dart';
import 'health_screen.dart';
import 'inventory_screen.dart';
import 'notifications_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'worker_screen.dart';

void main() => runApp(const PhakolApp());

// ---------------------------------------------------------------------------
// THEME
// ---------------------------------------------------------------------------
class AppColors {
  static const green = Color(0xFF1E6B2E);
  static const darkGreen = Color(0xFF14501F);
  static const bg = Color(0xFFF4F8F4);
  static const orange = Color(0xFFF59E0B);
  static const red = Color(0xFFDC2626);
}

class PhakolApp extends StatelessWidget {
  const PhakolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PHAKOL Poultry Farm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          primary: AppColors.green,
        ),
        scaffoldBackgroundColor: AppColors.bg,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. SPLASH SCREEN
// ---------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.egg_alt, size: 90, color: AppColors.green),
            SizedBox(height: 12),
            Text(
              'PHAKOL',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: AppColors.darkGreen,
              ),
            ),
            Text(
              'Poultry Farm',
              style: TextStyle(fontSize: 20, color: AppColors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Healthy Broilers • Better Yields • Greater Profits',
              style: TextStyle(fontSize: 12, color: AppColors.green),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. LOGIN SCREEN
// ---------------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidePassword = true;
  bool _remember = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Icon(Icons.egg_alt, size: 70, color: AppColors.green),
              const Center(
                child: Text(
                  'PHAKOL',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Sign in to continue',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  hintText: 'Email or Username',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _password,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _hidePassword = !_hidePassword),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _remember,
                    onChanged: (v) => setState(() => _remember = v ?? false),
                  ),
                  const Text('Remember me'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot password?'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RoleSelectScreen()),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.green,
                  side: const BorderSide(color: AppColors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. ROLE SELECTION
// ---------------------------------------------------------------------------
class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  void _go(BuildContext context, {required bool isWorker}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isWorker ? const WorkerShell() : const HomeShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 70, 24, 30),
            color: AppColors.green,
            child: const Column(
              children: [
                Text(
                  'PHAKOL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Select Your Role',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Choose how you want to use the app',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _RoleCard(
                  icon: Icons.person,
                  title: 'Farm Manager / Owner',
                  subtitle:
                      'Full access to all features, reports and settings.',
                  onTap: () => _go(context, isWorker: false),
                ),
                const SizedBox(height: 14),
                _RoleCard(
                  icon: Icons.engineering,
                  title: 'Farm Worker',
                  subtitle: 'Access to assigned tasks, record keeping and daily operations.',
                  onTap: () => _go(context, isWorker: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.green,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. HOME SHELL (bottom navigation) + DASHBOARD
// ---------------------------------------------------------------------------
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  late final List<Widget> _pages = [
    DashboardPage(onOpenHealth: () => setState(() => _index = 2)),
    const FlockScreen(),
    const HealthScreen(),
    const InventoryScreen(),
    const ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each tab's data alive when you switch tabs
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.egg_alt), label: 'Flocks'),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety),
            label: 'Health',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Reports'),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final VoidCallback onOpenHealth;

  const DashboardPage({super.key, required this.onOpenHealth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 56, 12, 20),
          color: AppColors.green,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
                child: const CircleAvatar(
                  radius: 22,
                  child: Icon(Icons.person),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning, John',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'PHAKOL Poultry Farm',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Notification bell with unread badge
              ListenableBuilder(
                listenable: notificationStore,
                builder: (context, _) {
                  final count = notificationStore.unreadCount;
                  return IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    ),
                    icon: Badge(
                      isLabelVisible: count > 0,
                      label: Text('$count'),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.7,
                children: const [
                  StatCard(
                    icon: Icons.egg_alt,
                    label: 'Total Birds',
                    value: '12,480',
                  ),
                  StatCard(
                    icon: Icons.layers,
                    label: 'Active Batches',
                    value: '6',
                  ),
                  StatCard(
                    icon: Icons.trending_up,
                    label: "Today's Weight Gain",
                    value: '1,240 g',
                  ),
                  StatCard(
                    icon: Icons.warning_amber,
                    label: 'Mortality Rate',
                    value: '0.32%',
                    color: AppColors.red,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 20),
              Card(
                color: Colors.white,
                elevation: 1,
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE3F1E5),
                    child: Icon(Icons.engineering, color: AppColors.green),
                  ),
                  title: const Text(
                    'Technical Operations',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Housing, water, biosecurity & maintenance',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
              ),

              // Upcoming vaccinations row (sample text for now)
              Card(
                color: Colors.white,
                elevation: 1,
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE3F1E5),
                    child: Icon(Icons.vaccines, color: AppColors.green),
                  ),
                  title: const Text(
                    'Upcoming Vaccinations',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('2 due this week'),
                  trailing: TextButton(
                    onPressed: onOpenHealth,
                    child: const Text('View All'),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Financial Summary (UGX)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.sell,
                      label: "Today's Sales",
                      value: '1,850,000',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.account_balance_wallet,
                      label: 'Net Profit',
                      value: '680,000',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color = AppColors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Used for screens that are not built yet
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title - coming soon')),
    );
  }
}
