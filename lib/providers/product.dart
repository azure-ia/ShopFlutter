import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> updateFavorite(String authToken, String userId) async {
    //optimistic updating
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
          Uri.https('shop-6f241-default-rtdb.europe-west1.firebasedatabase.app',
              'userFavorites/$userId/$id.json', {'auth': authToken}),
          body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        throw HttpException('Could not update product.');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      rethrow;
    }
  }
}
