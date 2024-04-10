import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .onPrimaryContainer
              .withOpacity(0.87),
          leading: Consumer<Product>(
            builder: ((ctx, productValue, childWidget) {
              return IconButton(
                icon: Icon(productValue.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).colorScheme.background,
                onPressed: () async {
                  try {
                    await Provider.of<Product>(context, listen: false)
                        .updateFavorite(
                      auth.token ?? '',
                      auth.userId ?? '',
                    );
                  } catch (error) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Update failed!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              );
            }),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItems(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Item added to the cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
