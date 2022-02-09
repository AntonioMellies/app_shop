import 'package:flutter/widgets.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Product.fromProduct(this.id, Product another)
      : name = another.name,
        description = another.description,
        price = another.price,
        imageUrl = another.imageUrl,
        isFavorite = another.isFavorite;

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
