import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import 'cart_screen.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';

  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _onlyFavorites = false;
  final bool _isInit = false;
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .catchError((error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occured'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    // Future.delayed(Duration.zero).then((_) =>
    //     {Provider.of<Products>(context, listen: false).fetchAndSetProducts()});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // if (!_isInit) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   Provider.of<Products>(context).fetchAndSetProducts().then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    // }
    // _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text('Only favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text('Show all'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedItm) {
              setState(() {
                switch (selectedItm) {
                  case FilterOptions.Favorites:
                    _onlyFavorites = true;
                    break;
                  case FilterOptions.All:
                    _onlyFavorites = false;
                    break;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, chld) {
              return BadgeWidget(
                value: cart.itemCount.toString(),
                child: chld!,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_onlyFavorites),
    );
  }
}
