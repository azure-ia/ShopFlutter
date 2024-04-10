import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_products_screen.dart';
import 'theme_data.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, prevProds) => Products(auth.token ?? '',
              auth.userId ?? '', prevProds == null ? [] : prevProds.items),
          create: (ctx) => Products('', '', []),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, prevOrds) => Orders(auth.token ?? '',
              auth.userId ?? '', prevOrds == null ? [] : prevOrds.orders),
          create: (ctx) => Orders('', '', []),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Shop',
          theme: THEMEDATA,
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => const ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
                builder: ((context) => const ProductsOverviewScreen()));
          },
        ),
      ),
    );
  }
}
