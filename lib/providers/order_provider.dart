import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/app_url_firebase.dart';

class OrderProvider with ChangeNotifier {
  final String _token;
  final String _uid;
  List<Order> _items = [];

  OrderProvider([
    this._token = '',
    this._uid = '',
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCounts {
    return _items.length;
  }

  Future<void> loadOrders() async {
    _items.clear();

    final response = await http.get(Uri.parse('${AppUrlFirebase.ORDER_URL}/${_uid}.json?auth=$_token'));
   
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      _items.add(Order(
        id: orderId,
        date: DateTime.parse(orderData['date']),
        total: orderData['total'],
        products: (orderData['products'] as List<dynamic>).map((item) {
          return CartItem(
            id: item['id'],
            productId: item['productId'],
            name: item['name'],
            quantity: item['quantity'],
            price: item['price'],
          );
        }).toList(),
      ));
    });
    notifyListeners();
  }

  Future<void> addOrder(double totalAmount, List<CartItem> products) async {
    final dateNow = DateTime.now();

    final response = await http.post(Uri.parse('${AppUrlFirebase.ORDER_URL}/${_uid}.json?auth=$_token'),
        body: jsonEncode({
          "date": dateNow.toIso8601String(),
          "total": totalAmount,
          "products": products.map((e) => {"id": e.id, "productId": e.productId, "name": e.name, "quantity": e.quantity, "price": e.price}).toList()
        }));

    final id = jsonDecode(response.body)['name'];

    _items.insert(
        0,
        Order(
          id: id,
          date: dateNow,
          total: totalAmount,
          products: products,
        ));
    notifyListeners();
  }
}
