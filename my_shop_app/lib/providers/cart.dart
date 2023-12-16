import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  //////+++++++++++++++++++++++++++++++++++++++++//////

  Map<String, CartItem> get items {
    return {..._items};
  }

  //////+++++++++++++++++++++++++++++++++++++++++//////

  void addItem({
    required String productId,
    required double price,
    required String title,
  }) {
    if (_items.containsKey(productId)) {
      // update the old cartItem
      _items.update(
        productId,
        (oldCartItem) => CartItem(
          id: oldCartItem.id,
          title: oldCartItem.title,
          quantity: oldCartItem.quantity + 1,
          price: oldCartItem.price,
        ),
      );
    } else {
      // create new cartItem
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: UniqueKey().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  //////+++++++++++++++++++++++++++++++++++++++++//////

  int get size {
    return _items.length;
  }

  //////+++++++++++++++++++++++++++++++++++++++++//////

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  //////+++++++++++++++++++++++++++++++++++++++++//////
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  //////+++++++++++++++++++++++++++++++++++++++++//////

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else {
      if (_items[productId]!.quantity > 1) {
        _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity - 1,
              price: existingCartItem.price),
        );
      } else {
        _items.remove(productId);
      }
    }
    notifyListeners();
  }

  //////+++++++++++++++++++++++++++++++++++++++++//////
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
