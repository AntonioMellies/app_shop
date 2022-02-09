import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/enums/filter_options.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/utils/app_routes.dart';

class ProductsOverviewPage extends StatefulWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Minha Loja',
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => const [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.all,
              )
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                switch (selectedValue) {
                  case FilterOptions.all:
                    _showFavoriteOnly = false;
                    break;
                  case FilterOptions.favorite:
                    _showFavoriteOnly = true;
                    break;
                }
              });
            },
          ),
          Consumer<CartProvider>(
            builder: (ctc, cartProvider, child) => Badge(
              value: cartProvider.itemsCount.toString(),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.CART);
                },
                icon: Icon(Icons.shopping_cart),
              ),
            ),
          )
        ],
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ProductGrid(_showFavoriteOnly),
      drawer: const AppDrawer(),
    );
  }
}
