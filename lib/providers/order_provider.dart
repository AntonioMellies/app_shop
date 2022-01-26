import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/models/product.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCounts {
    return _items.length;
  }

  void addOrder(double totalAmount, List<CartItem> products) {
    _items.insert(
        0,
        Order(
            id: Random().nextDouble().toString(),
            date: DateTime.now(),
            total: totalAmount,
            products: products));
    notifyListeners();
  }
}
