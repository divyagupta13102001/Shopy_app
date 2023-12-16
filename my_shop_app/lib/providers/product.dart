import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;

    // to make all the listeners activate
    notifyListeners();
    try {
      final response = await http.put(
        Uri.parse(
            'https://shopy-f4b81-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token'
            //   'https://firestore.googleapis.com/v1/projects/shopy-f4b81/databases/(default)/documents/userFavorites/$userId/$id?auth=$token',
            ),
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
