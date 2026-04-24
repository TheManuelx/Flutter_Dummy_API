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
}
