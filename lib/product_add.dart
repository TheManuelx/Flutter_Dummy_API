import 'package:flutter/material.dart';
import 'package:flutter_dummy_json/product_model.dart';

class ProductAddPage extends StatefulWidget {
  final int lastId;

  const ProductAddPage({super.key, required this.lastId});
  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'Image URL (https://...)'),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              hint: Text('Select Category'),
              items: [
                'beauty',
                'fragrances',
                'furniture',
                'groceries',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => selectedValue = v),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (titleController.text.isEmpty || priceController.text.isEmpty || selectedValue == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Input all * ')),
                  );
                  return;
                }

                final imgUrl = imageController.text.trim().isEmpty? 'https://placeholder.com' : imageController.text.trim();
                final newProduct = Product(
                  id: widget.lastId + 1,
                  title: titleController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  category: selectedValue ?? '',
                  rating: 0.0,
                  stock: 10,
                  sku: 'N/A',
                  weight: 0,
                  dimensions: Dimensions(width: 0, height: 0, depth: 0),
                  warrantyInformation: 'No Warranty',
                  shippingInformation: 'Standard Shipping',
                  availabilityStatus: 'In Stock',
                  reviews: [],
                  returnPolicy: 'No Return',
                  minimumOrderQuantity: 1,
                  images: [imgUrl],
                  thumbnail: imgUrl,
                );
                Navigator.pop(context, newProduct);
              },
              child: Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
