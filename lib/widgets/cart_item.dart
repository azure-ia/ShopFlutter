import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(this.id, this.productId, this.price, this.quantity, this.title,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content:
                const Text('Do you want to remove this item from the cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('No'),
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: ListTile(
            leading: Chip(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: Padding(
                padding: const EdgeInsets.all(1),
                child: FittedBox(
                  child: Text('\$${(price * quantity)}',
                      style: Theme.of(context).primaryTextTheme.labelLarge),
                ),
              ),
            ),
            title: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w500)),
            subtitle: Text('Price: \$$price',
                style: Theme.of(context).textTheme.labelLarge),
            trailing: Text(
              '$quantity x',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }
}
