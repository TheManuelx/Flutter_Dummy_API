import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dummy_json/product_model.dart';

class ApiService {
  final String baseUrl = "https://dummyjson.com";

  Future<List<Product>> fetchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/products/search?q=$query'));

    if (response.statusCode == 200) {

      Map<String, dynamic> data = jsonDecode(response.body);

      List<dynamic> list = data['products'];

      return list.map((e) => Product.fromJson(e)).toList();
    } else {
        throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String categoryName) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$categoryName'));

    if (response.statusCode == 200) {

      Map<String, dynamic> data = jsonDecode(response.body);

      List<dynamic> list = data['products'];

      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products in $categoryName');
    }
  }

  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/products/category-list'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load Catagories');
    }
  }

  Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/add'),
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'category': product.category,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add Product');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': product.title,
      }),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to Update Product');
    }
  }
}
