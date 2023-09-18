import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../models/user.dart';

class CartNotifier with ChangeNotifier {
  List<Product> cartProducts = [];
  final _cartBox = Hive.box<Cart>("cartBox");
  final _userBox = Hive.box<User>("userBox");

  CartNotifier() {
    final user = _userBox.get(0); // Assuming user data is stored at index 0
    if (user != null) {
      final userId = user.id;
      final cart = _cartBox.get(0);
      if (cart != null /*&& cart.userId == int.parse(userId)*/) {
        cartProducts = cart.products;
      }
    }
  }
  // Save the cart to the cartBox
  Future<void> saveCart() async {
    final cart = Cart(products: cartProducts,);
    await _cartBox.put(0, cart);
  }

  // adding product
  addToCart(Product product) {
    cartProducts.add(product);
    saveCart();
    notifyListeners();
  }

  // removing product
  removeFromCart(Product product) {
    cartProducts.remove(product);
    saveCart();
    notifyListeners();
  }

  void updateQuantity(Product product, int newQuantity) {
    final int index = cartProducts.indexOf(product);
    if (index != -1) {
      cartProducts[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  // loading product from the hive store into provider
  CartNotifier.all(List<Product> products) {
    cartProducts = products;
    notifyListeners();
  }

  // empty cart
  clearCart() {
    cartProducts.clear();
    notifyListeners();
  }

  // Getter for the total price of the cart
  double get total {
    double totalPrice = 0.0;
    for (var product in cartProducts) {
      totalPrice += double.parse(product.price) * product.quantity!;
    }
    return totalPrice;
  }
}
