import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items;
  final String _authToken;
  final String _authUserId;

  Products(this._authToken, this._authUserId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterUserId = false]) async {
    final requestParams = filterUserId
        ? {
            'auth': _authToken,
            'orderBy': '"creatorId"',
            'equalTo': '"$_authUserId"'
          }
        : {'auth': _authToken};
    try {
      final responseProducts = await http.get(
        Uri.https('shop-6f241-default-rtdb.europe-west1.firebasedatabase.app',
            'products.json', requestParams),
      );

      final productsData =
          json.decode(responseProducts.body) as Map<String, dynamic>;

      final responseFavorites = await http.get(
        Uri.https('shop-6f241-default-rtdb.europe-west1.firebasedatabase.app',
            'userFavorites/$_authUserId.json', {'auth': _authToken}),
      );
      final favoritesData =
          json.decode(responseFavorites.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      productsData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoritesData == null ? false : favoritesData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.https('shop-6f241-default-rtdb.europe-west1.firebasedatabase.app',
            'products.json', {'auth': _authToken}),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': _authUserId,
        }),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Could not create product.');
      }
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        final response = await http.patch(
            Uri.https(
                'shop-6f241-default-rtdb.europe-west1.firebasedatabase.app',
                'products/$id.json',
                {'auth': _authToken}),
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            }));
        if (response.statusCode >= 400) {
          throw HttpException('Could not update product.');
        }
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    //optimistic updating
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    try {
      final response = await http.delete(
        Uri.https('shop-6f241-default-rtdb.europe-west1.firebasedatabase.app',
            'products/$id.json', {'auth': _authToken}),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product.');
      }
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      rethrow;
    }
    existingProduct = null;
  }
}
