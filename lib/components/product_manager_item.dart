import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/utils/app_routes.dart';

class ProductManagerItem extends StatelessWidget {
  final Product product;
  const ProductManagerItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Tem Certeza?'),
                    content: const Text('Quer remover o item do carrinho?'),
                    actions: [
                      TextButton(
                        child: const Text('Não'),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Sim'),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      )
                    ],
                  ),
                ).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      ).delete(product);
                    } on HttpException catch (error) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
