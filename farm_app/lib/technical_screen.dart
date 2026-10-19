import 'package:flutter/material.dart';
import 'main.dart'; // for AppColors

const _shortMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String _formatDate(DateTime d) =>
    '${_shortMonths[d.month - 1]} ${d.day}, ${d.year}';

// ---------------------------------------------------------------------------
// NOTES MODEL + SHARED STORE
// ---------------------------------------------------------------------------
class FarmNote {
  final String title;
  final String details;
  final DateTime created;

  const FarmNote({
    required this.title,
    required this.details,
    required this.created,
  });
}

class NotesStore extends ChangeNotifier {
  final List<FarmNote> notes = [
    // SAMPLE note
    FarmNote(
      title: 'Check generator fuel',
      details: 'Top up before the weekend in case of a power cut.',
      created: DateTime.now(),
    ),
  ];

  void add(FarmNote note) {
    notes.insert(0, note);
    notifyListeners();
  }

  void remove(FarmNote note) {
    notes.remove(note);
    notifyListeners();
  }
}

final notesStore = NotesStore();

/// Opens the "Add Note" form. Used by both screens in this file.
void showAddNoteSheet(BuildContext context) {
  final title = TextEditingController();
  final details = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Add Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: title,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: details,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: 'Details (optional)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (title.text.trim().isEmpty) return;
                notesStore.add(FarmNote(
                  title: title.text.trim(),
                  details: details.text.trim(),
                  created: DateTime.now(),
                ));
                Navigator.pop(ctx);
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      );
    },
  );
}

// ---------------------------------------------------------------------------
// TECHNICAL OPERATIONS SCREEN
// ---------------------------------------------------------------------------
class TechnicalScreen extends StatelessWidget {
  const TechnicalScreen({super.key});

  void _comingSoon(BuildContext context, String name) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$name - coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Technical Operations')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _OpsCard(
                  icon: Icons.home_work,
                  title: 'Housing & Equipment',
                  subtitle:
                      'Manage houses, ventilation, lighting, heating and power systems.',
                  onTap: () => _comingSoon(context, 'Housing & Equipment'),
                ),
                _OpsCard(
                  icon: Icons.water_drop,
                  title: 'Water & Utilities',
                  subtitle: 'Monitor water supply, quality and power status.',
                  onTap: () => _comingSoon(context, 'Water & Utilities'),
                ),
                _OpsCard(
                  icon: Icons.shield,
                  title: 'Biosecurity',
                  subtitle: 'Farm hygiene, visitor logs, disease prevention.',
                  onTap: () => _comingSoon(context, 'Biosecurity'),
                ),
                _OpsCard(
                  icon: Icons.build,
                  title: 'Maintenance',
                  subtitle: 'Schedule and track repairs and maintenance.',
                  onTap: () => _comingSoon(context, 'Maintenance'),
                ),
                _OpsCard(
                  icon: Icons.edit_note,
                  title: 'Farm Notes',
                  subtitle: 'Add important notes and reminders.',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotesScreen()),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: ElevatedButton.icon(
              onPressed: () => showAddNoteSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Note'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OpsCard({
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
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F1E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.green, size: 26),
        ),
        title: Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(subtitle, style: const TextStyle(fontSize: 12)),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FARM NOTES SCREEN
// ---------------------------------------------------------------------------
class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Notes')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        onPressed: () => showAddNoteSheet(context),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: notesStore,
        builder: (context, _) {
          final notes = notesStore.notes;

          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet. Tap + to add one.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: notes.length,
            itemBuilder: (_, i) {
              final note = notes[i];
              return Dismissible(
                key: ObjectKey(note),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => notesStore.remove(note),
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.title,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        if (note.details.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(note.details,
                              style: const TextStyle(fontSize: 13)),
                        ],
                        const SizedBox(height: 6),
                        Text(_formatDate(note.created),
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black45)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}