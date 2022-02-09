import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product_manager_item.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/utils/app_routes.dart';

class ProductsManagerPage extends StatefulWidget {
  const ProductsManagerPage({Key? key}) : super(key: key);

  @override
  State<ProductsManagerPage> createState() => _ProductsManagerPageState();
}

class _ProductsManagerPageState extends State<ProductsManagerPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).loadProducts().then((value) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productProvider.itemsCount,
                itemBuilder: (context, index) => Column(
                  children: [ProductManagerItem(productProvider.items[index]), const Divider()],
                ),
              ),
            ),
    );
  }
}
