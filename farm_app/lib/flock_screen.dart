import 'package:flutter/material.dart';
import 'main.dart'; // for AppColors

// ---------------------------------------------------------------------------
// MODEL
// ---------------------------------------------------------------------------
class Batch {
  final String id;
  final String breed;
  final int birds;
  final int ageDays;
  final int house;
  final String type; // e.g. Broiler
  final String status; // Active or Completed

  const Batch({
    required this.id,
    required this.breed,
    required this.birds,
    required this.ageDays,
    required this.house,
    this.type = 'Broiler',
    this.status = 'Active',
  });
}

// ---------------------------------------------------------------------------
// SCREEN
// ---------------------------------------------------------------------------
class FlockScreen extends StatefulWidget {
  const FlockScreen({super.key});

  @override
  State<FlockScreen> createState() => _FlockScreenState();
}

class _FlockScreenState extends State<FlockScreen> {
  final List<Batch> _batches = [
    const Batch(id: 'B001', breed: 'Ross 308', birds: 1500, ageDays: 28, house: 1),
    const Batch(id: 'B002', breed: 'Cobb 500', birds: 1200, ageDays: 21, house: 2),
    const Batch(id: 'B003', breed: 'Ross 308', birds: 1000, ageDays: 14, house: 3),
    const Batch(id: 'B004', breed: 'Cobb 500', birds: 800, ageDays: 7, house: 4),
    const Batch(
        id: 'B000',
        breed: 'Ross 308',
        birds: 1400,
        ageDays: 42,
        house: 1,
        status: 'Completed'),
  ];

  final List<String> _filters = ['All Batches', 'Broilers', 'Active', 'Completed'];
  String _selectedFilter = 'All Batches';
  String _query = '';

  List<Batch> get _visibleBatches {
    return _batches.where((b) {
      final matchesSearch = _query.isEmpty ||
          b.id.toLowerCase().contains(_query.toLowerCase()) ||
          b.breed.toLowerCase().contains(_query.toLowerCase());

      final matchesFilter = switch (_selectedFilter) {
        'Broilers' => b.type == 'Broiler',
        'Active' => b.status == 'Active',
        'Completed' => b.status == 'Completed',
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _openAddBatchSheet() {
    final breed = TextEditingController();
    final birds = TextEditingController();
    final house = TextEditingController();

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
              const Text('Add New Batch',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: breed,
                decoration: const InputDecoration(hintText: 'Breed (e.g. Ross 308)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: birds,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Number of birds'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: house,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'House number'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final count = int.tryParse(birds.text);
                  final houseNo = int.tryParse(house.text);
                  if (breed.text.trim().isEmpty ||
                      count == null ||
                      houseNo == null) {
                    return; // ignore incomplete forms
                  }
                  setState(() {
                    _batches.insert(
                      0,
                      Batch(
                        id: 'B${(_batches.length + 1).toString().padLeft(3, '0')}',
                        breed: breed.text.trim(),
                        birds: count,
                        ageDays: 0,
                        house: houseNo,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Save Batch'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final batches = _visibleBatches;

    return Scaffold(
      appBar: AppBar(title: const Text('Flock & Batch Management')),
      body: Column(
        children: [
          // Search + Add Batch
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'Search batches...',
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                  ),
                  onPressed: _openAddBatchSheet,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Batch'),
                ),
              ],
            ),
          ),

          // Filter chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final selected = f == _selectedFilter;
                return ChoiceChip(
                  label: Text(f),
                  selected: selected,
                  selectedColor: AppColors.green,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.green,
                  ),
                  checkmarkColor: Colors.white,
                  onSelected: (_) => setState(() => _selectedFilter = f),
                );
              },
            ),
          ),

          // Batch list
          Expanded(
            child: batches.isEmpty
                ? const Center(child: Text('No batches found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: batches.length,
                    itemBuilder: (_, i) => BatchCard(batch: batches[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BATCH CARD
// ---------------------------------------------------------------------------
class BatchCard extends StatelessWidget {
  final Batch batch;
  const BatchCard({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final isActive = batch.status == 'Active';

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFFE3F1E5),
              child: Icon(Icons.egg_alt, size: 30, color: AppColors.green),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Batch ${batch.id}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    '${batch.breed} • ${_formatNumber(batch.birds)} birds',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  Text(
                    'Age: ${batch.ageDays} days • House ${batch.house}',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFDDF0E0) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                batch.status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.green : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1500 -> "1,500"
  String _formatNumber(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}