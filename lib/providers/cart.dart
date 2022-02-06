import 'package:flutter/cupertino.dart';

class CartItem {
  @required
  final String id;
  @required
  final String title;
  @required
  final double price;
  @required
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  //map that will map product id to a cart item instance
  //note that prodcut id and cart item id are two different ids
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get numProducts {
    return _items.length;
  }

  double get getTotal {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItemToCart(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingProduct) {
        return CartItem(
          id: existingProduct.id,
          title: existingProduct.title,
          price: existingProduct.price,
          quantity: existingProduct.quantity + 1,
        );
      });
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }

    notifyListeners();
  }

  void removeItemFromCart(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                price: existingItem.price,
                title: existingItem.title,
                quantity: existingItem.quantity - 1,
              ));
    }
    else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
