import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    //optimistic update is when we roll back updates locally if remote update failed
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        '#add your own firebase link$userId/$id.json?auth=$authToken');
    //put request instead of patch, and we're sending the value only not a map 
    final response = await http.put(url, body: json.encode( isFavorite));
    if(response.statusCode >= 400)
    {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException('Failed to change favorite status');
    }
  }
}
