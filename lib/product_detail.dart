import 'package:flutter/material.dart';
import 'package:flutter_dummy_json/product_model.dart';
import 'package:flutter_dummy_json/product_update.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

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