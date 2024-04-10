import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  'Price: \$${loadedProduct.price}',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final productId = ModalRoute.of(context)?.settings.arguments as String;
  //   final productItem =
  //       Provider.of<Products>(context, listen: false).findById(productId);

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(productItem.title),
  //     ),
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           Container(
  //             height: 250,
  //             width: double.infinity,
  //             child: Image.network(
  //               productItem.imageUrl,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           Text('Price: \$${productItem.price}',
  //               style: Theme.of(context).textTheme.titleLarge),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Container(
  //             padding: EdgeInsets.symmetric(horizontal: 10),
  //             width: double.infinity,
  //             child: Text(productItem.description,
  //                 textAlign: TextAlign.center,
  //                 softWrap: true,
  //                 style: Theme.of(context).textTheme.labelLarge),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
