import 'package:flutter/material.dart';
import 'main.dart'; // for AppColors

// ---------------------------------------------------------------------------
// MODEL
// ---------------------------------------------------------------------------
class StockItem {
  final String name;
  final IconData icon;
  final String unit; // bags, types, items
  final int lowThreshold;
  int quantity;

  StockItem({
    required this.name,
    required this.icon,
    required this.unit,
    required this.quantity,
    required this.lowThreshold,
  });

  String get status {
    if (quantity <= 0) return 'Out';
    if (quantity <= lowThreshold) return 'Low';
    return 'Good';
  }
}

// ---------------------------------------------------------------------------
// SCREEN
// ---------------------------------------------------------------------------
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<StockItem> _feed = [
    StockItem(
        name: 'Starter Feed',
        icon: Icons.grain,
        unit: 'bags',
        quantity: 25,
        lowThreshold: 10),
    StockItem(
        name: 'Grower Feed',
        icon: Icons.grain,
        unit: 'bags',
        quantity: 120,
        lowThreshold: 30),
    StockItem(
        name: 'Finisher Feed',
        icon: Icons.grain,
        unit: 'bags',
        quantity: 90,
        lowThreshold: 30),
  ];

  final List<StockItem> _other = [
    StockItem(
        name: 'Vaccines',
        icon: Icons.vaccines,
        unit: 'types',
        quantity: 6,
        lowThreshold: 2),
    StockItem(
        name: 'Medications',
        icon: Icons.medication,
        unit: 'types',
        quantity: 8,
        lowThreshold: 2),
    StockItem(
        name: 'Equipment',
        icon: Icons.build,
        unit: 'items',
        quantity: 5,
        lowThreshold: 1),
  ];

  List<StockItem> get _allItems => [..._feed, ..._other];

  void _openAddStockSheet() {
    StockItem selected = _allItems.first;
    final qty = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Add Stock',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<StockItem>(
                      value: selected,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: _allItems
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(item.name),
                              ))
                          .toList(),
                      onChanged: (item) {
                        if (item != null) setSheetState(() => selected = item);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: qty,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Quantity to add (${selected.unit})',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final amount = int.tryParse(qty.text);
                      if (amount == null || amount <= 0) return;
                      setState(() => selected.quantity += amount);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Added $amount ${selected.unit} to ${selected.name}'),
                        ),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feed & Inventory'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Feed'),
              Tab(text: 'Inventory'),
              Tab(text: 'Purchases'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStockTab(),
            const Center(child: Text('Inventory - coming soon')),
            const Center(child: Text('Purchases - coming soon')),
          ],
        ),
      ),
    );
  }

  Widget _buildStockTab() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionTitle('Feed Stock'),
              ..._feed.map((item) => StockCard(item: item)),
              const SizedBox(height: 12),
              const _SectionTitle('Other Inventory'),
              ..._other.map((item) => StockCard(item: item)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: ElevatedButton.icon(
            onPressed: _openAddStockSheet,
            icon: const Icon(Icons.add),
            label: const Text('Add Stock'),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

// ---------------------------------------------------------------------------
// STOCK CARD
// ---------------------------------------------------------------------------
class StockCard extends StatelessWidget {
  final StockItem item;
  const StockCard({super.key, required this.item});

  Color get _statusBg {
    switch (item.status) {
      case 'Out':
        return const Color(0xFFFDE2E2);
      case 'Low':
        return const Color(0xFFFEF0D3);
      default:
        return const Color(0xFFDDF0E0);
    }
  }

  Color get _statusFg {
    switch (item.status) {
      case 'Out':
        return AppColors.red;
      case 'Low':
        return const Color(0xFFB45309);
      default:
        return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFE3F1E5),
              child: Icon(item.icon, color: AppColors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('${item.quantity} ${item.unit}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _statusFg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}