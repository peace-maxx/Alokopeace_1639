import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedMethod = 0; // 0: Cash, 1: Card, 2: Mobile Money, 3: Bank Transfer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Column(
                children: const [
                  Text('Total Amount', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('UGX 8,260', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildPaymentOption(0, 'Cash', Icons.money),
            _buildPaymentOption(1, 'Credit / Debit Card', Icons.credit_card),
            _buildPaymentOption(2, 'Mobile Money (MTN / Airtel)', Icons.phone_android),
            _buildPaymentOption(3, 'Bank Transfer', Icons.account_balance),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Process payment action
                },
                child: const Text('Pay Now', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(int index, String title, IconData icon) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: RadioListTile<int>(
        value: index,
        groupValue: _selectedMethod,
        onChanged: (val) => setState(() => _selectedMethod = val!),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        secondary: Icon(icon, color: Colors.blue),
        activeColor: Colors.blue,
      ),
    );
  }
}