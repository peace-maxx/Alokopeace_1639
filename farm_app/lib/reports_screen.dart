import 'package:flutter/material.dart';
import 'main.dart'; // for AppColors
import 'production_screen.dart';
import 'finance_screen.dart';

// ---------------------------------------------------------------------------
// MODEL
// ---------------------------------------------------------------------------
class ReportType {
  final String title;
  final String subtitle;
  final IconData icon;

  const ReportType({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

const _reports = [
  ReportType(
    title: 'Production Report',
    subtitle: 'Weight, growth, mortality',
    icon: Icons.precision_manufacturing,
  ),
  ReportType(
    title: 'Sales Report',
    subtitle: 'Revenue & customers',
    icon: Icons.bar_chart,
  ),
  ReportType(
    title: 'Financial Report',
    subtitle: 'Expenses & profit',
    icon: Icons.account_balance_wallet,
  ),
  ReportType(
    title: 'Inventory Report',
    subtitle: 'Stock & purchases',
    icon: Icons.inventory_2,
  ),
  ReportType(
    title: 'Health Report',
    subtitle: 'Vaccinations & treatments',
    icon: Icons.health_and_safety,
  ),
  ReportType(
    title: 'Flock Report',
    subtitle: 'Batch performance',
    icon: Icons.egg_alt,
  ),
];

// ---------------------------------------------------------------------------
// SCREEN
// ---------------------------------------------------------------------------
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _openExportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Export Report',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: AppColors.red),
                title: const Text('Export as PDF'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showMessage(context, 'PDF export - coming soon');
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart, color: AppColors.green),
                title: const Text('Export as Excel'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showMessage(context, 'Excel export - coming soon');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reports & Analytics'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Flock'),
              Tab(text: 'Production'),
              Tab(text: 'Finance'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverview(context),
            const Center(child: Text('Flock analytics - coming soon')),
            const Center(child: Text('Production analytics - coming soon')),
            const Center(child: Text('Finance analytics - coming soon')),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
            children: _reports
                .map((r) => ReportCard(
                      report: r,
                    onTap: () {
                      final Widget? page = switch (r.title) {
                        'Production Report' => const ProductionScreen(),
                        'Sales Report' || 'Financial Report' => const FinanceScreen(),
                          _ => null,
                      };
                      if (page == null) {
                        _showMessage(context, '${r.title} - coming soon');
                          return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => page),
                      );
                    },
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: ElevatedButton.icon(
            onPressed: () => _openExportSheet(context),
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Export PDF / Excel'),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// REPORT CARD
// ---------------------------------------------------------------------------
class ReportCard extends StatelessWidget {
  final ReportType report;
  final VoidCallback onTap;

  const ReportCard({super.key, required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFE3F1E5),
                child: Icon(report.icon, size: 28, color: AppColors.green),
              ),
              const SizedBox(height: 10),
              Text(
                report.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                report.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}