// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_notifier.dart';
import '../../controllers/order_notifier.dart';
import '../../models/cart.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../services/request.dart';
import '../components/cart/cart_card.dart';
import '../components/cart/check_out_screen.dart';
import '../components/cart/empty_cart.dart';
import '../utils/constant.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _userBox = Hive.box<User>("userBox");
  bool deleteCart = false;
  Future _checkOutModal(context, User? user, Cart cart) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return CheckOutScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _userBox.getAt(0);
    final productList = Provider.of<CartNotifier>(context).cartProducts;
    final orderList = Provider.of<OrderNotifier>(context).orderList;
    print(orderList.length);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Consumer<CartNotifier>(
            builder: (context, cartNotifier, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(color: appBarBg),
                    alignment: Alignment.center,
                    child: Text(
                      "Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 40,
                        color: appBarBg,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffedf7f6),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Builder(
                              builder: (BuildContext context) {
                                if ((productList.isNotEmpty)) {
                                  return Column(
                                    children: [
                                      Column(
                                        children: List.generate(
                                          productList.length,
                                          (i) {
                                            final product = productList[i];
                                            return InkWell(
                                              onDoubleTap: () {
                                                setState(() {
                                                  deleteCart = !deleteCart;
                                                });
                                              },
                                              child: CartCard(
                                                  deleteCart: deleteCart,
                                                  product: product),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return EmptyCart();
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Total:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "\u20A6${(cartNotifier.total).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            _saveOrder(user, cartNotifier);
                            // _checkOutModal(context, user, cart);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: appBarBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Checkout >>",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _saveOrder(User? user, CartNotifier cartNotifier) {
    final user = _userBox.values.elementAt(0);
    final cart = Cart(products: cartNotifier.cartProducts);
    final total = cart.total;
    final userId = user.id;
    final products = cart.products;
    final productIds = cart.products.map((product) => product.id).toList();
    final quantities =
        cart.products.map((product) => product.quantity).toList();
    final details = List<Detail>.generate(
      productIds.length,
      (index) => Detail(
        productId: productIds[index]!,
        quantity: quantities[index]!,
        product: products[index],
      ),
    );

    final order = Order(
      userId: userId!,
      total: total.toString(),
      detail: details,
    );

    saveOrder(order, context);
  }

  Future<void> saveOrder(Order order, BuildContext context) async {
    // Show a loading indicator while saving a order
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //request to the server
    final response = await post('order', order.toMap());
    print(response.data);
    if (response.data['success'] != null) {
      context.read<CartNotifier>().clearCart();
      order = Order.fromMap(response.data['success']);
      context.read<OrderNotifier>().addOrder(order);
      Navigator.pushReplacementNamed(context, "/orders");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Order Failed'),
          content: Text(
              'Oh no! It seems like there was an error while trying to submit your order for the product.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
