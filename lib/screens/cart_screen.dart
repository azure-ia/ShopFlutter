import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart' as WidgetCartItem;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).primaryTextTheme.titleMedium,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OrderButton(cart)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => WidgetCartItem.CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton(this.cart, {super.key});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  void createOrder(BuildContext context, Cart cart) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Orders>(context, listen: false).addOrder(
        cart.items.values.toList(),
        cart.totalAmount,
      );
      cart.clear();
    } catch (error) {
      await showDialog(
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: _isLoading ? const CircularProgressIndicator() : const Text('ORDER NOW'),
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () {
              createOrder(context, widget.cart);
            },
    );
  }
}
