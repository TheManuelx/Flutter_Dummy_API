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
}
