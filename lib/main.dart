import 'package:flutter/material.dart';
import 'package:flutter_dummy_json/product_model.dart';
import 'package:flutter_dummy_json/api_service.dart';
import 'package:flutter_dummy_json/product_detail.dart';
import 'package:flutter_dummy_json/product_search.dart';
import 'package:flutter_dummy_json/product_add.dart';
import 'package:flutter_dummy_json/product_update.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Store App'),
        '/detail': (context) => ProductDetailPage(),
        '/search': (context) => ProductSearchPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  late TabController _tabController;

  List<Product> products = [];
  List<Product> locallyAddedProducts = [];
  bool isLoading = true;

  final List<String> categories = [
    'All',
    'beauty',
    'fragrances',
    'furniture',
    'groceries',
  ];

  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _loadProducts('All');

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadProducts(categories[_tabController.index]);
      }
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          String selectedCategory = categories[_tabController.index];
          if (selectedCategory == 'All') {
            _productsFuture = apiService.fetchProductsByCategory('..');
          } else {
            _productsFuture = apiService.fetchProductsByCategory(
              selectedCategory,
            );
          }
        });
      }
    });
  }

  Future<void> _loadProducts(String category) async {
    setState(() => isLoading = true);
    try {
      List<Product> data;
      if (category == 'All') {
        data = await apiService.fetchProducts('');
      } else {
        data = await apiService.fetchProductsByCategory(category);
      }

      List<Product> localFilltered = locallyAddedProducts.where((p) {
        return category == 'All' || p.category == category;
      }).toList();

      setState(() {
        products = [...localFilltered, ...data];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((cat) => Tab(text: cat)).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              int lastId = products.isNotEmpty ? products.last.id : 0;
              final newProduct = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductAddPage(lastId: lastId),
                ),
              );
              if (newProduct != null && newProduct is Product) {
                setState(() {
                  locallyAddedProducts.insert(0, newProduct);
                  products.insert(0, newProduct);
                });
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: product,
                  ),
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: product.images.isNotEmpty
                              ? Image.network(
                                  product.images[0],
                                  fit: BoxFit.contain,
                                )
                              : const Icon(Icons.image_not_supported),
                        ),
                        Text(product.title),
                        Text(
                          '\$${product.price}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
