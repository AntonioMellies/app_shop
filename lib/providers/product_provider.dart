import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_url_firebase.dart';

class ProductProvider with ChangeNotifier {
  final String _token;
  final String _uid;
  List<Product> _items = [];

  ProductProvider([
    this._token = '',
    this._uid = '',
    this._items = const [],
  ]);

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((element) => element.isFavorite).toList();

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(Uri.parse('${AppUrlFirebase.PRODUCT_URL}.json?auth=$_token'));

    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('${AppUrlFirebase.USER_FAVORITES_URL}/${_uid}.json?auth=$_token'),
    );
    Map<String, dynamic> favData = favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;
      _items.add(Product(
        id: productId,
        name: productData['name'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        isFavorite: isFavorite,
      ));
    });
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;
    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return update(product);
    } else {
      return save(product);
    }
  }

  Future<void> save(Product product) async {
    final response = await http.post(Uri.parse('${AppUrlFirebase.PRODUCT_URL}.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        }));

    final id = jsonDecode(response.body)['name'];
    _items.add(Product.fromProduct(id, product));
    notifyListeners();
  }

  Future<void> update(Product product) async {
    await http.patch(Uri.parse('${AppUrlFirebase.PRODUCT_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        }));

    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> delete(Product product) async {
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      final productRestore = _items[index];
      _items.remove(productRestore);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${AppUrlFirebase.PRODUCT_URL}/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, productRestore);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possivel exluir o produto',
          statusCode: response.statusCode,
        );
      }
    }
  }

  Future<void> toggleFavorite(Product product, String uid) async {
    int index = _items.indexWhere((element) => element.id == product.id);
    _items[index].toggleFavorite();
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('${AppUrlFirebase.USER_FAVORITES_URL}/${uid}/${_items[index].id}.json?auth=$_token'),
        body: jsonEncode(_items[index].isFavorite),
      );

      if (response.statusCode >= 400) {
        _items[index].toggleFavorite();
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possivel marcar o produto como favorito',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print(e);
      _items[index].toggleFavorite();
      notifyListeners();
    }
  }

  int get itemsCount {
    return _items.length;
  }
}
