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
    final cart = Cart(
      products: cartProducts,
    );
    await _cartBox.put(0, cart);
  }

  // Adding product to cart with duplicate handling
  void addToCart(Product product) {
    // Check if the product already exists in the cart
    int existingIndex = _findProductIndex(product);

    if (existingIndex != -1) {
      // Product already exists, increment quantity
      cartProducts[existingIndex].quantity =
          (cartProducts[existingIndex].quantity ?? 1) + (product.quantity ?? 1);
    } else {
      // Product doesn't exist, add it with quantity (default to 1 if null)
      product.quantity ??= 1;
      cartProducts.add(product);
    }

    saveCart();
    notifyListeners();
  }

  // Helper method to find a product in the cart
  int _findProductIndex(Product product) {
    // Compare product by ID if available
    if (product.id != null) {
      return cartProducts.indexWhere((item) => item.id == product.id);
    }

    // If no ID (which should be rare), compare by name, price and other attributes
    return cartProducts.indexWhere((item) =>
        item.name == product.name &&
        item.price == product.price &&
        item.brand == product.brand);
  }

  // removing product
  removeFromCart(Product product) {
    cartProducts.remove(product);
    saveCart();
    notifyListeners();
  }

  void updateQuantity(Product product, int newQuantity) {
    final int index = _findProductIndex(product);
    if (index != -1) {
      cartProducts[index].quantity = newQuantity;
      saveCart(); // Save the updated cart
      notifyListeners();
    }
  }

  // loading product from the hive store into provider
  CartNotifier.all(List<Product> products) {
    cartProducts = products;
    notifyListeners();
  }

  // Empty cart
  void clearCart() {
    cartProducts.clear();
    saveCart(); // Save the empty cart
    notifyListeners();
  }

  // Getter for the total price of the cart
  double get total {
    double totalPrice = 0.0;
    for (var product in cartProducts) {
      totalPrice += double.parse(product.price) * (product.quantity ?? 1);
    }
    return totalPrice;
  }

  // Get the total number of items in cart (counting quantities)
  int get itemCount {
    int count = 0;
    for (var product in cartProducts) {
      count += product.quantity ?? 1;
    }
    return count;
  }

  // Remove a specific product
  void removeProduct(Product product) {
    int index = _findProductIndex(product);
    if (index != -1) {
      cartProducts.removeAt(index);
      saveCart();
      notifyListeners();
    }
  }
}
