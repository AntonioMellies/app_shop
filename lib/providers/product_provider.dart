import 'package:flutter/widgets.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((element) => element.isFavorite).toList();

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    _items.firstWhere((element) => element.id == product.id).toggleFavorite();
    notifyListeners();
  }

   int get itemsCount {
    return _items.length;
  }
}
