import 'package:flutter/material.dart';
import 'main.dart'; // for AppColors

const _shortMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String _formatDate(DateTime d) => '${_shortMonths[d.month - 1]} ${d.day}, ${d.year}';

// 1820000 -> "1,820,000"
String _formatUgx(int n) {
  final s = n.abs().toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return n < 0 ? '-$buf' : buf.toString();
}

// ---------------------------------------------------------------------------
// MODEL
// ---------------------------------------------------------------------------
class Txn {
  final String title;
  final bool isSale; // true = sale (money in), false = expense (money out)
  final int amount;
  final DateTime date;

  const Txn({
    required this.title,
    required this.isSale,
    required this.amount,
    required this.date,
  });
}

// ---------------------------------------------------------------------------
// SCREEN
// ---------------------------------------------------------------------------
class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  late final DateTime _today;
  late final List<Txn> _txns;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);

    // SAMPLE DATA (dates kept inside the current month)
    DateTime daysAgo(int n) =>
        DateTime(_today.year, _today.month, (_today.day - n).clamp(1, 31));

    _txns = [
      Txn(title: 'Chicken Sales - 200 birds', isSale: true, amount: 1820000, date: daysAgo(0)),
      Txn(title: 'Feed Purchase', isSale: false, amount: 1050000, date: daysAgo(1)),
      Txn(title: 'Medicine Purchase', isSale: false, amount: 320000, date: daysAgo(1)),
      Txn(title: 'Chicken Sales - 350 birds', isSale: true, amount: 3150000, date: daysAgo(2)),
      Txn(title: 'Labour Wages', isSale: false, amount: 600000, date: daysAgo(3)),
    ];
  }

  // Only this month's transactions, newest first
  List<Txn> get _monthTxns {
    final list = _txns
        .where((t) => t.date.year == _today.year && t.date.month == _today.month)
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  int get _totalSales =>
      _monthTxns.where((t) => t.isSale).fold(0, (sum, t) => sum + t.amount);

  int get _totalExpenses =>
      _monthTxns.where((t) => !t.isSale).fold(0, (sum, t) => sum + t.amount);

  void _openAddSheet() {
    bool isSale = true;
    final title = TextEditingController();
    final amount = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Add Transaction',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Sale'),
                      selected: isSale,
                      selectedColor: AppColors.green,
                      labelStyle:
                          TextStyle(color: isSale ? Colors.white : Colors.black87),
                      checkmarkColor: Colors.white,
                      onSelected: (_) => setSheetState(() => isSale = true),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Expense'),
                      selected: !isSale,
                      selectedColor: AppColors.red,
                      labelStyle:
                          TextStyle(color: !isSale ? Colors.white : Colors.black87),
                      checkmarkColor: Colors.white,
                      onSelected: (_) => setSheetState(() => isSale = false),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                      hintText: 'Description (e.g. Feed Purchase)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Amount (UGX)'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final value = int.tryParse(amount.text);
                    if (title.text.trim().isEmpty || value == null || value <= 0) {
                      return;
                    }
                    setState(() {
                      _txns.add(Txn(
                        title: title.text.trim(),
                        isSale: isSale,
                        amount: value,
                        date: _today,
                      ));
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sales & Financial Records'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Sales'),
              Tab(text: 'Expenses'),
              Tab(text: 'Suppliers'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          onPressed: _openAddSheet,
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            _buildSalesTab(),
            _buildExpensesTab(),
            const Center(child: Text('Suppliers - coming soon')),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRange() {
    final start = DateTime(_today.year, _today.month, 1);
    final end = DateTime(_today.year, _today.month + 1, 0);
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_formatDate(start)} - ${_formatDate(end)}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const Icon(Icons.calendar_month, color: AppColors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTab() {
    final net = _totalSales - _totalExpenses;
    final txns = _monthTxns;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        _buildDateRange(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Total Sales',
                value: _formatUgx(_totalSales),
                icon: Icons.sell,
                color: AppColors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'Total Expenses',
                value: _formatUgx(_totalExpenses),
                icon: Icons.warning_amber,
                color: AppColors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          label: 'Net Profit',
          value: _formatUgx(net),
          icon: Icons.account_balance_wallet,
          color: net >= 0 ? AppColors.green : AppColors.red,
        ),
        const SizedBox(height: 20),
        const Text('Recent Transactions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (txns.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No transactions this month')),
          )
        else
          ...txns.map((t) => _TxnTile(txn: t)),
      ],
    );
  }

  Widget _buildExpensesTab() {
    final expenses = _monthTxns.where((t) => !t.isSale).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        _buildDateRange(),
        const SizedBox(height: 12),
        _SummaryCard(
          label: 'Total Expenses',
          value: _formatUgx(_totalExpenses),
          icon: Icons.warning_amber,
          color: AppColors.red,
        ),
        const SizedBox(height: 20),
        const Text('Expenses',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (expenses.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No expenses this month')),
          )
        else
          ...expenses.map((t) => _TxnTile(txn: t)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// SUMMARY CARD
// ---------------------------------------------------------------------------
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(value,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
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

// ---------------------------------------------------------------------------
// TRANSACTION TILE
// ---------------------------------------------------------------------------
class _TxnTile extends StatelessWidget {
  final Txn txn;
  const _TxnTile({required this.txn});

  @override
  Widget build(BuildContext context) {
    final color = txn.isSale ? AppColors.green : AppColors.red;

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                txn.isSale ? Icons.trending_up : Icons.trending_down,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(txn.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(_formatDate(txn.date),
                      style: const TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
            Text(
              'UGX ${_formatUgx(txn.amount)}',
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}