import 'package:flutter/foundation.dart';

import '../models/http_exception.dart';
import './cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String _authToken;
  final String _authUserId;

  Orders(this._authToken, this._authUserId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final response = await http.get(
        Uri.https('shop-6f241-default-rtdb.europe-west1.firebasedatabase.app',
            'orders/$_authUserId.json', {'auth': _authToken}),
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((ordId, ordData) {
        loadedOrders.add(OrderItem(
          id: ordId,
          amount: ordData['amount'],
          dateTime: DateTime.parse(ordData['dateTime']),
          products: (ordData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        Uri.https('shop-6f241-default-rtdb.europe-west1.firebasedatabase.app',
            'orders/$_authUserId.json', {'auth': _authToken}),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList()
        }),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Could not create Order.');
      }
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
