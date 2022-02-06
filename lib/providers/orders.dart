import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  @required
  String id;
  @required
  double total;
  @required
  List<CartItem> items;
  @required
  DateTime orderDate;

  OrderItem({this.id, this.total, this.items, this.orderDate});

  bool isOrderEmpty() {
    if (items.isEmpty)
      return true;
    else
      return false;
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String _authToken;
  final String _userId;
  Orders(this._authToken, this._userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double orderTotal) async {
    final url = Uri.parse(
        '#add your own firebase link/$_userId.json?auth=$_authToken');
    final dateTime = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'total': orderTotal,
          'dateTime': dateTime.toIso8601String(),
          'products': cartProducts
              .map((prod) => {
                    'id': prod.id,
                    'title': prod.title,
                    'price': prod.price,
                    'quantity': prod.quantity
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        total: orderTotal,
        items: cartProducts,
        orderDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        '#add your own firebase link$_userId.json?auth=$_authToken');
    final response = await http.get(url);
    print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          total: orderData['total'],
          //parse here accept Iso8601 String format that why we set it in that format when sending to fire base
          orderDate: DateTime.parse(orderData['dateTime']),
          items: (orderData['products'] as List<dynamic>)
              .map(
                (cartItem) => CartItem(
                    id: cartItem['id'],
                    price: cartItem['price'],
                    quantity: cartItem['quantity'],
                    title: cartItem['title']),
              )
              .toList(),
        ),
      );
    });
    //to show the newest order on top of the page 
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
