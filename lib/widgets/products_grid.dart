import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _onlyFavorites;
  const ProductsGrid(this._onlyFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productsItems =
        _onlyFavorites ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productsItems.length,
      itemBuilder: (ctx, ind) => ChangeNotifierProvider.value(
        value: productsItems[ind],
        child: const ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
