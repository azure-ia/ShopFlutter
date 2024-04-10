import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product _product;

  const UserProductItem(this._product, {super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(_product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: _product.id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(_product.id);
                } catch (error) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
