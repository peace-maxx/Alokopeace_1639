import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'main.dart'; // for AppColors

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

// ---------------------------------------------------------------------------
// SCREEN (tabs)
// ---------------------------------------------------------------------------
class ProductionScreen extends StatelessWidget {
  const ProductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Production Tracking'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Live Performance'),
              Tab(text: 'Batch Performance'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LivePerformanceTab(),
            Center(child: Text('Batch Performance - coming soon')),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LIVE PERFORMANCE TAB
// ---------------------------------------------------------------------------
class LivePerformanceTab extends StatefulWidget {
  const LivePerformanceTab({super.key});

  @override
  State<LivePerformanceTab> createState() => _LivePerformanceTabState();
}

class _LivePerformanceTabState extends State<LivePerformanceTab> {
  late DateTime _month;
  late final DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _month = _currentMonth;
  }

  void _changeMonth(int delta) {
    final next = DateTime(_month.year, _month.month + delta);
    if (next.isAfter(_currentMonth)) return; // no future months
    setState(() => _month = next);
  }

  int get _daysInMonth => DateTime(_month.year, _month.month + 1, 0).day;

  // SAMPLE DATA: replace with real records from your database later.
  // Returns average daily weight gain (grams) for each day of the month.
  List<double> get _dailyGain {
    return List.generate(_daysInMonth, (i) {
      final day = i + 1;
      return 350.0 + day * 14 + ((day * 37 + _month.month * 13) % 90);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gains = _dailyGain;
    final avgGain = gains.reduce((a, b) => a + b) / gains.length;
    final atCurrent = _month == _currentMonth;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Month selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeMonth(-1),
            ),
            Text(
              '${_monthNames[_month.month - 1]} ${_month.year}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: atCurrent ? null : () => _changeMonth(1),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Total live weight
        Card(
          color: Colors.white,
          elevation: 1,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFE3F1E5),
                  child: Icon(Icons.scale, color: AppColors.green, size: 28),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Live Weight',
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                    Text('18,640 kg',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    Text('↑ 6% vs last month',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.green,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Daily weight gain chart
        Card(
          color: Colors.white,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 12),
                  child: Text('Daily Weight Gain (g)',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 200, child: _buildChart(gains)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Bottom stats
        Row(
          children: [
            Expanded(
              child: _MiniStat(
                  label: 'Avg. Daily Gain',
                  value: '${avgGain.round()} g'),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: _MiniStat(label: 'Feed Conversion', value: '1.72'),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: _MiniStat(label: 'Mortality Rate', value: '0.32%'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChart(List<double> gains) {
    const labelStyle = TextStyle(fontSize: 10, color: Colors.black54);
    final days = gains.length;

    return BarChart(
      BarChartData(
        maxY: 1000,
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 250,
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: 250,
              getTitlesWidget: (value, meta) =>
                  Text(value.toInt().toString(), style: labelStyle),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final d = value.toInt();
                final show = d == 1 || (d % 5 == 0 && d <= days - 2) || d == days;
                if (!show) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('$d', style: labelStyle),
                );
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                'Day ${group.x}\n${rod.toY.round()} g',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            },
          ),
        ),
        barGroups: List.generate(days, (i) {
          return BarChartGroupData(
            x: i + 1,
            barRods: [
              BarChartRodData(
                toY: gains[i],
                width: 5,
                color: AppColors.green,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(2)),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MINI STAT CARD
// ---------------------------------------------------------------------------
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}