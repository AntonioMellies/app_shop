import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem Vindo Usuário!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Loja'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCTS_MANAGER);
            },
          ),
          const Divider(),
          ListTile(
            
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
            },
          ),
        ],
      ),
    );
  }
}
