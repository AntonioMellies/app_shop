import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item_widget.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/order_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of(context);
    final OrderProvider orderProvider = Provider.of(context, listen: false);
    final items = cartProvider.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text('R\$ ${cartProvider.totalAmount}'),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6?.color,
                    ),
                  ),
                  const Spacer(),
                  BuyButton(cartProvider: cartProvider, orderProvider: orderProvider, items: items),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => CartItemWidget(items[index]),
            ),
          )
        ],
      ),
    );
  }
}

class BuyButton extends StatefulWidget {
  const BuyButton({
    Key? key,
    required this.cartProvider,
    required this.orderProvider,
    required this.items,
  }) : super(key: key);

  final CartProvider cartProvider;
  final OrderProvider orderProvider;
  final List<CartItem> items;

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cartProvider.itemsCount == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    await widget.orderProvider.addOrder(widget.cartProvider.totalAmount, widget.items);
                    widget.cartProvider.clear();
                    setState(() => _isLoading = false);
                  },
            child: const Text("Comprar"),
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
  }
}
