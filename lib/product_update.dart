import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dummy_json/api_service.dart';
import 'package:flutter_dummy_json/product_model.dart';

class ProductUpdatePage extends StatefulWidget{
  final Product product;
  const ProductUpdatePage({super.key, required this.product});

  @override
  _ProductUpdatePageState createState() => _ProductUpdatePageState();

}

class _ProductUpdatePageState extends State<ProductUpdatePage>{
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  final apiSerVice = ApiService();
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
  }

  void _updateData() async {
    widget.product.title = _titleController.text;
    try {
      if (_titleController.text.isEmpty) return;

      widget.product.title = _titleController.text;

      print("Sending Update Request...");
      //await apiSerVice.updateProduct(widget.product.id, widget.product);

      print("Update Success");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated Successfully'))
      );
      Navigator.pop(context, widget.product);
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Product Title"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _updateData,
                  child: const Text("Save Change"),
              )
            ],
          ),
        ),
      ),
    );
  }

}