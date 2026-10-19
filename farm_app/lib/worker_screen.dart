// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import 'flock_screen.dart';
import 'health_screen.dart';
import 'main.dart'; // for AppColors and LoginScreen

const _shortMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String _formatDateTime(DateTime t) {
  final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final minute = t.minute.toString().padLeft(2, '0');
  final ampm = t.hour >= 12 ? 'PM' : 'AM';
  return '${_shortMonths[t.month - 1]} ${t.day}, $hour12:$minute $ampm';
}

// ---------------------------------------------------------------------------
// RECORDS LOG (shared, in memory)
// ---------------------------------------------------------------------------
class LogEntry {
  final String type; // 'Feed & Water', 'Health Check', 'Mortality'
  final String summary;
  final DateTime time;

  const LogEntry({
    required this.type,
    required this.summary,
    required this.time,
  });
}

class WorkerLog extends ChangeNotifier {
  final List<LogEntry> entries = [];

  void add(LogEntry entry) {
    entries.insert(0, entry);
    notifyListeners();
  }
}

final workerLog = WorkerLog();

// ---------------------------------------------------------------------------
// RECORD FORM (one reusable bottom sheet for all three record types)
// ---------------------------------------------------------------------------
class _FieldSpec {
  final String label;
  final bool numeric;
  const _FieldSpec(this.label, {this.numeric = false});
}

// Sample batch list. Replace with your real batches once data is stored.
const _batchIds = ['B001', 'B002', 'B003', 'B004'];

void _openRecordSheet(
  BuildContext context, {
  required String title,
  required String type,
  required List<_FieldSpec> fields,
  required String Function(String batch, List<String> values) summary,
}) {
  final controllers = fields.map((_) => TextEditingController()).toList();
  String batch = _batchIds.first;

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
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: batch,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: _batchIds
                      .map((b) =>
                          DropdownMenuItem(value: b, child: Text('Batch $b')))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setSheetState(() => batch = v);
                  },
                ),
              ),
              for (int i = 0; i < fields.length; i++) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: controllers[i],
                  keyboardType: fields[i].numeric
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  decoration: InputDecoration(hintText: fields[i].label),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final values = controllers.map((c) => c.text.trim()).toList();
                  for (int i = 0; i < fields.length; i++) {
                    final bad = values[i].isEmpty ||
                        (fields[i].numeric &&
                            double.tryParse(values[i]) == null);
                    if (bad) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                            content: Text('Please fill in all fields')));
                      return;
                    }
                  }
                  workerLog.add(LogEntry(
                    type: type,
                    summary: summary(batch, values),
                    time: DateTime.now(),
                  ));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text('$type recorded')));
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

// ---------------------------------------------------------------------------
// WORKER SHELL (bottom navigation)
// ---------------------------------------------------------------------------
class WorkerShell extends StatefulWidget {
  const WorkerShell({super.key});

  @override
  State<WorkerShell> createState() => _WorkerShellState();
}

class _WorkerShellState extends State<WorkerShell> {
  int _index = 0;

  late final List<Widget> _pages = [
    WorkerHome(onOpenTasks: () => setState(() => _index = 1)),
    const TasksScreen(),
    const HealthScreen(),
    const RecordsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
          NavigationDestination(
              icon: Icon(Icons.health_and_safety), label: 'Health'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Records'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WORKER HOME
// ---------------------------------------------------------------------------
class WorkerHome extends StatelessWidget {
  final VoidCallback onOpenTasks;
  const WorkerHome({super.key, required this.onOpenTasks});

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout',
                style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PHAKOL Poultry Farm'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'logout') _logout(context);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile
          Card(
            color: Colors.white,
            elevation: 1,
            child: const ListTile(
              leading: CircleAvatar(radius: 24, child: Icon(Icons.person)),
              title: Text('Joseph',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Text('Farm Worker'),
            ),
          ),
          const SizedBox(height: 8),

          _ActionCard(
            icon: Icons.checklist,
            title: 'My Tasks',
            subtitle: "Today's assigned tasks",
            onTap: onOpenTasks,
          ),
          _ActionCard(
            icon: Icons.water_drop,
            title: 'Record Feed & Water',
            subtitle: 'Update daily consumption',
            onTap: () => _openRecordSheet(
              context,
              title: 'Record Feed & Water',
              type: 'Feed & Water',
              fields: const [
                _FieldSpec('Feed used (bags)', numeric: true),
                _FieldSpec('Water used (litres)', numeric: true),
              ],
              summary: (batch, v) =>
                  'Batch $batch: ${v[0]} bags feed, ${v[1]} L water',
            ),
          ),
          _ActionCard(
            icon: Icons.health_and_safety,
            title: 'Health Check',
            subtitle: 'Report any sick or unusual birds',
            onTap: () => _openRecordSheet(
              context,
              title: 'Health Check',
              type: 'Health Check',
              fields: const [
                _FieldSpec('Birds affected', numeric: true),
                _FieldSpec('What did you notice?'),
              ],
              summary: (batch, v) => 'Batch $batch: ${v[0]} birds - ${v[1]}',
            ),
          ),
          _ActionCard(
            icon: Icons.heart_broken,
            title: 'Record Mortality',
            subtitle: 'Record birds that died today',
            onTap: () => _openRecordSheet(
              context,
              title: 'Record Mortality',
              type: 'Mortality',
              fields: const [
                _FieldSpec('Birds died', numeric: true),
                _FieldSpec('Likely cause'),
              ],
              summary: (batch, v) => 'Batch $batch: ${v[0]} died - ${v[1]}',
            ),
          ),
          _ActionCard(
            icon: Icons.egg_alt,
            title: 'View Batch Info',
            subtitle: 'Assigned batches',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AssignedBatchesScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(top: 10),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F1E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.green),
        ),
        title: Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TASKS TAB
// ---------------------------------------------------------------------------
class _Task {
  final String title;
  bool done;
  _Task(this.title, {this.done= false});
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // SAMPLE tasks: later these will be assigned by the manager.
  final List<_Task> _tasks = [
    _Task('Morning feeding - House 1'),
    _Task('Morning feeding - House 2'),
    _Task('Check water lines'),
    _Task('Remove dead birds and record mortality'),
    _Task('Clean drinkers'),
    _Task('Evening feeding round'),
  ];

  @override
  Widget build(BuildContext context) {
    final doneCount = _tasks.where((t) => t.done).length;

    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('$doneCount of ${_tasks.length} completed',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.darkGreen)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _tasks.isEmpty ? 0 : doneCount / _tasks.length,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            color: AppColors.green,
            backgroundColor: const Color(0xFFD7E8D9),
          ),
          const SizedBox(height: 16),
          ..._tasks.map(
            (t) => Card(
              color: Colors.white,
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 10),
              child: CheckboxListTile(
                value: t.done,
                activeColor: AppColors.green,
                onChanged: (v) => setState(() => t.done = v ?? false),
                title: Text(
                  t.title,
                  style: TextStyle(
                    decoration: t.done ? TextDecoration.lineThrough : null,
                    color: t.done ? Colors.black45 : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// RECORDS TAB (everything the worker has recorded)
// ---------------------------------------------------------------------------
class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  IconData _iconFor(String type) {
    switch (type) {
      case 'Feed & Water':
        return Icons.water_drop;
      case 'Health Check':
        return Icons.health_and_safety;
      default:
        return Icons.heart_broken;
    }
  }

  Color _colorFor(String type) =>
      type == 'Mortality' ? AppColors.red : AppColors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Records')),
      body: ListenableBuilder(
        listenable: workerLog,
        builder: (context, _) {
          final entries = workerLog.entries;
          if (entries.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nothing recorded yet.\nUse the Home tab to add records.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (_, i) {
              final e = entries[i];
              final color = _colorFor(e.type);
              return Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.12),
                    child: Icon(_iconFor(e.type), color: color),
                  ),
                  title: Text(e.type,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${e.summary}\n${_formatDateTime(e.time)}'),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ASSIGNED BATCHES (read only)
// ---------------------------------------------------------------------------
class AssignedBatchesScreen extends StatelessWidget {
  const AssignedBatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SAMPLE: later this will show only the batches assigned to this worker.
    const assigned = [
      Batch(id: 'B001', breed: 'Ross 308', birds: 1500, ageDays: 28, house: 1),
      Batch(id: 'B002', breed: 'Cobb 500', birds: 1200, ageDays: 21, house: 2),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Assigned Batches')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: assigned.map((b) => BatchCard(batch: b)).toList(),
      ),
    );
  }
}