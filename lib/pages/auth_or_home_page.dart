import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/providers/auth_provider.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);
    return FutureBuilder(
        future: authProvider.tryAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return const Center(
              child: Text("Ocorreu um erro!"),
            );
          } else {
            return authProvider.isAuth ? ProductsOverviewPage() : AuthPage();
          }
        });
  }
}
