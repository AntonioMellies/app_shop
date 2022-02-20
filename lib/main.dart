import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_manager_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/order_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (context) => ProductProvider(),
          update: (context, auth, previous) {
            return ProductProvider(
              auth.token ?? '',
              auth.uid ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (context) => OrderProvider(),
          update: (context, auth, previous) {
            return OrderProvider(
              auth.token ?? '',
              auth.uid ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromRGBO(55, 0, 222, 1),
            secondary: const Color.fromRGBO(32, 215, 0, 1),
          ),
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          AppRoutes.PRODUCT_DATAIL: (ctx) => ProductDetailPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
          AppRoutes.PRODUCTS_MANAGER: (ctx) => ProductsManagerPage(),
          AppRoutes.CART: (ctx) => CartPage(),
          AppRoutes.ORDERS: (ctx) => OrdersPage(),
        },
      ),
    );
  }
}
