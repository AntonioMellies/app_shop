import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order_widget.dart';
import 'package:shop/providers/order_provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).loadOrders().then((value) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderProvider.itemsCounts,
              itemBuilder: (context, index) => OrderWidget(order: orderProvider.items[index]),
            ),
    );
  }
}
