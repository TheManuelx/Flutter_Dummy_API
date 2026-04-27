import 'package:flutter/material.dart';
import 'package:flutter_dummy_json/api_service.dart';
import 'package:flutter_dummy_json/product_model.dart';
import 'package:flutter_dummy_json/product_update.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  void _confirmDelete() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confiem Delete"),
          content: const Text("Are you sure you want to delete this Product?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
            ),
            TextButton(
                onPressed: () async {
                  try {
                    final apiService = ApiService();
                    await apiService.deleteProduct(currentProduct!.id);

                    if (!mounted) return;
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Product deleted Successfully')),
                    );

                    Navigator.pop(context, 'deleted');
                  } catch(e) {
                    print(e);
                  }
                },
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
    );
  }
  Product? currentProduct;
  @override
  Widget build(BuildContext context) {

    currentProduct ??= ModalRoute.of(context)!.settings.arguments as Product;
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Product Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
              onPressed: () async {

                final updatedProduct = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductUpdatePage(product: currentProduct!),
                    ),
                );

                if (updatedProduct != null && updatedProduct is Product) {
                  setState(() {
                    currentProduct = updatedProduct;
                  });
                }
              },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: (Colors.red)),
            onPressed: () {
              _confirmDelete();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
                product.images[0], height: 300, fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.price}  ',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                      Text('Rating: ${product.rating}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(product.description ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}