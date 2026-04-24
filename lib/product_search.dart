import 'package:flutter/material.dart';
import 'package:flutter_dummy_json/product_model.dart';
import 'package:flutter_dummy_json/api_service.dart';

class ProductSearchPage extends StatefulWidget {
  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search Product...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: ApiService().fetchProducts(_searchText),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Product Not Found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return ListTile(
                leading: Image.network(product.thumbnail, width: 50),
                title: Text(product.title),
                subtitle: Text("${product.price} USD"),
                onTap: () {
                  Navigator.pushNamed(context, '/detail', arguments: product);
                },
              );
            },
          );
        },
      ),
    );
  }
}
