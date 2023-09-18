import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/request.dart';

class OrderNotifier with ChangeNotifier {
  List<Order> orderList = [];

  Future<void> fetchData(String userId) async {
    var orderResponse = await get('order/$userId/detail');
    List<dynamic> orderData = orderResponse.data;
    orderList.clear(); // Clear the existing list before adding new data
    for (var order in orderData) {
      orderList.add(Order.fromMap(order));
    }
    notifyListeners();
  }

  // adding order
  addOrder(Order order) {
    orderList.add(order);
    notifyListeners();
  }

  // loading order from the database into provider
  OrderNotifier.all(List<Order> orders) {
    orderList = orders;
    notifyListeners();
  }

  // delete order
  deleteOrder(Order order) {
    orderList.remove(order);
    notifyListeners();
  }

  // clear order
  clearOrder() {
    orderList.clear();
    notifyListeners();
  }
}
