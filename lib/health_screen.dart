import 'package:flutter/material.dart';
import 'main.dart'; // for AppColors

// ---------------------------------------------------------------------------
// MODEL
// ---------------------------------------------------------------------------
class Vaccination {
  final String name;
  final DateTime dueDate;
  final int birds;
  bool done;

  Vaccination({
    required this.name,
    required this.dueDate,
    required this.birds,
    this.done = false,
  });
}

const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];
const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

// ---------------------------------------------------------------------------
// SCREEN (tabs)
// ---------------------------------------------------------------------------
class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Health & Vaccination'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Vaccinations'),
              Tab(text: 'Health Records'),
              Tab(text: 'Alerts'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VaccinationsTab(),
            _ComingSoon(label: 'Health Records'),
            _ComingSoon(label: 'Alerts'),
          ],
        ),
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final String label;
  const _ComingSoon({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('$label - coming soon'));
  }
}

// ---------------------------------------------------------------------------
// VACCINATIONS TAB
// ---------------------------------------------------------------------------
class VaccinationsTab extends StatefulWidget {
  const VaccinationsTab({super.key});

  @override
  State<VaccinationsTab> createState() => _VaccinationsTabState();
}

class _VaccinationsTabState extends State<VaccinationsTab> {
  late final DateTime _today;
  late DateTime _selected;
  late DateTime _weekStart; // Monday of the week being shown
  late final List<Vaccination> _vaccinations;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selected = _today;
    _weekStart = DateTime(_today.year, _today.month, _today.day - (_today.weekday - 1));

    // Sample data: due dates are relative to today.
    DateTime inDays(int n) => DateTime(_today.year, _today.month, _today.day + n);
    _vaccinations = [
      Vaccination(name: 'Newcastle Disease', dueDate: inDays(2), birds: 1500),
      Vaccination(name: 'Gumboro (IBD)', dueDate: inDays(8), birds: 1500),
      Vaccination(name: "Marek's Disease", dueDate: inDays(15), birds: 1500),
    ];
  }

  void _moveWeek(int weeks) {
    setState(() {
      _weekStart = DateTime(
          _weekStart.year, _weekStart.month, _weekStart.day + 7 * weeks);
    });
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _hasVaccination(DateTime day) =>
      _vaccinations.any((v) => _sameDay(v.dueDate, day));

  String _dueText(DateTime due) {
    final diff = due.difference(_today).inDays;
    if (diff == 0) return 'Due today';
    if (diff == 1) return 'Due tomorrow';
    if (diff < 0) return 'Overdue by ${-diff} days';
    return 'Due in $diff days';
  }

  String _dateText(DateTime d) =>
      '${_months[d.month - 1].substring(0, 3)} ${d.day}, ${d.year}';

  @override
  Widget build(BuildContext context) {
    // Use the middle of the week for the month label (handles week spanning 2 months)
    final labelDate =
        DateTime(_weekStart.year, _weekStart.month, _weekStart.day + 3);
    final days = List.generate(
      7,
      (i) => DateTime(_weekStart.year, _weekStart.month, _weekStart.day + i),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Calendar card
        Card(
          color: Colors.white,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => _moveWeek(-1),
                    ),
                    Text(
                      '${_months[labelDate.month - 1]} ${labelDate.year}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => _moveWeek(1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days.map(_buildDayCell).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Upcoming Vaccinations',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),

        // Vaccination cards
        ..._vaccinations.map(_buildVaccinationCard),
      ],
    );
  }

  Widget _buildDayCell(DateTime day) {
    final isSelected = _sameDay(day, _selected);
    final isToday = _sameDay(day, _today);

    return GestureDetector(
      onTap: () => setState(() => _selected = day),
      child: Column(
        children: [
          Text(_weekdays[day.weekday - 1],
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.green : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.green)
                  : null,
            ),
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // dot marks a day with a vaccination due
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: _hasVaccination(day) ? AppColors.orange : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationCard(Vaccination v) {
    final highlighted = _sameDay(v.dueDate, _selected);

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: highlighted ? AppColors.green : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // Tap a card to toggle done / scheduled
        onTap: () => setState(() => v.done = !v.done),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFE3F1E5),
                child: Icon(Icons.vaccines, color: AppColors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(
                      '${_dueText(v.dueDate)} • ${_dateText(v.dueDate)}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Text(
                      '${v.birds.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')} birds',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: v.done
                      ? AppColors.green
                      : const Color(0xFFDDF0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  v.done ? 'Done' : 'Scheduled',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: v.done ? Colors.white : AppColors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}