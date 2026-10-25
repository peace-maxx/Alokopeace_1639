import 'package:flutter/material.dart';

class ReportsAnalyticsScreen extends StatelessWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Tabs
            Row(
              children: [
                _buildFilterTab('Sales', true),
                const SizedBox(width: 8),
                _buildFilterTab('Inventory', false),
                const SizedBox(width: 8),
                _buildFilterTab('Customers', false),
              ],
            ),
            const SizedBox(height: 16),
            // Date Filter Buttons
            Row(
              children: const [
                Chip(label: Text('7 Days', style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
                SizedBox(width: 8),
                Chip(label: Text('30 Days')),
                SizedBox(width: 8),
                Chip(label: Text('Custom')),
              ],
            ),
            const SizedBox(height: 16),
            // Total Sales Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Sales', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 8),
                  const Text('UGX 8,450,000', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text('15% increase', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Sales Trend Graph Mock Area
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sales Trend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  Center(
                    child: Text(
                      '[ Interactive Line Chart Widget Area ]',
                      style: TextStyle(color: Colors.grey.shade400, fontStyle: FontStyle.italic),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
        ),
        child: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}