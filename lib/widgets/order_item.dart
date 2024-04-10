
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$${widget.order.amount}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView.builder(
                itemBuilder: ((ctx, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.order.products[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${widget.order.products[index].quantity}x \$${widget.order.products[index].price}',
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  );
                }),
                itemCount: widget.order.products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            )
        ],
      ),
    );
  }
}
