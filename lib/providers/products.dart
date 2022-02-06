import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'product.dart';


class Products with ChangeNotifier {
  String _authToken;
  String _userId;
  Products(this._authToken, this._userId, this._items);

  List<Product> _items = [

  ];

  List<Product> get items {
    return [
      ..._items
    ];
  }

  List<Product> get filteredItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }


  Future<void> addProduct(Product newProduct) async {
    final url = Uri.parse(
        '#add your own firebase link.json?auth=$_authToken');
    //returning the whole block because post return future and then also return future
    //in this case Future of the then will be returned once the then block executes and a product is added
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'creatorId': _userId
          }));
      final Product toBeAdded = Product(
          title: newProduct.title,
          price: newProduct.price,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl,
          id: json.decode(response.body)['name']);
      _items.add(toBeAdded);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error; //throwing the error here to catch it in edit product screen where we get stuck in a circular progesses indicator in case of errors.
    }
  }


  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';

    var url = Uri.parse(
        'https://flutter-shop-app-eaa6a-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString');
    try {
      var response = await http.get(url);
      //print(json.decode(response.body)); //FireBase return Map<String, Map> for Products where String is the ID
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; //dart does not understand a Map with Map values
      final List<Product> loadedProducts = [];

      //get user specific favorties using his id
      url = Uri.parse(
          '#add your own firebase link/$_userId.json?auth=$_authToken');
      response = await http.get(url);
      final favoriteData = json.decode(
          response.body); //Map<String, bool) productId and bool for favorite

      if (extractedData == null) return;

      extractedData.forEach((prodId, productData) {
        loadedProducts.add(Product(
            id: prodId,
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            title: productData['title'],
            //?? checks if the value before it is null
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      //we throw error here but we do not handle it in products_overview_screen... not the focus of the module
      print(error);
      throw (error);
    }
  }



  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          '#add your own firebase link/$id.json?auth=$_authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        '#add your own firebase link/$id.json?auth=$_authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[
        existingProductIndex]; //remove product from _list but keep a copy of it
    _items.removeAt(existingProductIndex);
    notifyListeners();

    //Same code as above but using async and await
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Failed to delete');
    }
    existingProduct = null;
  }

  void updateUser(String token, String id) {
    this._userId = id;
    this._authToken = token;
    notifyListeners();
  }
}
