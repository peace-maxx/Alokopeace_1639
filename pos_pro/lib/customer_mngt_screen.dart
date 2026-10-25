import 'package:flutter/material.dart';

class CustomerManagementScreen extends StatelessWidget {
  const CustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> customers = [
      {'name': 'John Mwangi', 'phone': '+256 700 123 456'},
      {'name': 'Sarah Nakato', 'phone': '+256 772 987 654'},
      {'name': 'David Kato', 'phone': '+256 703 456 789'},
      {'name': 'Aisha Namulindwa', 'phone': '+256 751 234 567'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: Text(customer['name']![0], style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(customer['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(customer['phone']!, style: const TextStyle(color: Colors.grey)),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: const Text('Add Customer', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}