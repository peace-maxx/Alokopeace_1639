import 'package:flutter/material.dart';

class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['All', 'Beverages', 'Snacks', 'Groceries'];

  // Mock product catalog data matching the wireframe
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Coca Cola 500ml',
      'price': 'UGX 2,500',
      'stock': 50,
      'category': 'Beverages',
    },
    {
      'name': 'Sprite 500ml',
      'price': 'UGX 2,500',
      'stock': 40,
      'category': 'Beverages',
    },
    {
      'name': 'Water 500ml',
      'price': 'UGX 1,500',
      'stock': 100,
      'category': 'Beverages',
    },
    {
      'name': 'Bread',
      'price': 'UGX 3,000',
      'stock': 30,
      'category': 'Groceries',
    },
    {
      'name': 'Chips 200g',
      'price': 'UGX 2,000',
      'stock': 45,
      'category': 'Snacks',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter products based on selected category tab
    final filteredProducts = _selectedCategoryIndex == 0
        ? _products
        : _products
              .where(
                (p) => p['category'] == _categories[_selectedCategoryIndex],
              )
              .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          // Search Bar & Filter Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Category Horizontal Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: isSelected,
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: Colors.white,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Product List Grid / ListView
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Product Thumbnail Placeholder
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product['price'],
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Stock: ${product['stock']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Add to Cart Action Button
                        IconButton(
                          onPressed: () {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(content: Text('${product['name']} added to cart')),
                            // );
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
