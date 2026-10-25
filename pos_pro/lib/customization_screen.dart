import 'package:flutter/material.dart';

class BusinessProfileCustomizationScreen extends StatelessWidget {
  const BusinessProfileCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Business Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'My Store',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Business Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: 'Retail Store',
              items: const [
                DropdownMenuItem(value: 'Retail Store', child: Text('Retail Store')),
                DropdownMenuItem(value: 'Restaurant', child: Text('Restaurant')),
                DropdownMenuItem(value: 'Pharmacy', child: Text('Pharmacy')),
              ],
              onChanged: (val) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Theme Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              children: const [
                CircleAvatar(backgroundColor: Colors.blue, radius: 18),
                SizedBox(width: 12),
                CircleAvatar(backgroundColor: Colors.purple, radius: 18),
                SizedBox(width: 12),
                CircleAvatar(backgroundColor: Colors.green, radius: 18),
                SizedBox(width: 12),
                CircleAvatar(backgroundColor: Colors.orange, radius: 18),
                SizedBox(width: 12),
                CircleAvatar(backgroundColor: Colors.black87, radius: 18),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}