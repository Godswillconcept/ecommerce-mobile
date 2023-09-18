// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ecommerce/controllers/cart_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../../services/request.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    super.key,
    required this.deleteCart,
    required this.product,
  });

  final bool deleteCart;
  final Product product;

  void removeProductFromCart(BuildContext context, CartNotifier cartNotifier) {
    cartNotifier.removeFromCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} removed from cart'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      ),
    );
  }

  void increaseQty(CartNotifier cartNotifier) {
    final int currentQuantity = product.quantity ?? 0;
    cartNotifier.updateQuantity(product, currentQuantity + 1);
  }

  void decreaseQty(CartNotifier cartNotifier) {
    if (product.quantity! > 1) {
      final int currentQuantity = product.quantity ?? 0;
    cartNotifier.updateQuantity(product, currentQuantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = double.parse(product.price) * product.quantity!;
    return Consumer<CartNotifier>(
      builder: (context, cartNotifier, child) {
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    deleteCart
                        ? InkWell(
                            onTap: () {
                              cartNotifier.removeFromCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('${product.name} removed from cart'),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(right: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              child: Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : SizedBox(),
                    Container(
                      width: 70,
                      height: 70,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.lightBlue),
                        image: DecorationImage(
                          image: NetworkImage(baseUrl + product.image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 180,
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Unit cost: \u20A6${product.price}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Total: \u20A6${totalPrice.toStringAsFixed(2)}", // Display total price per product
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => increaseQty(cartNotifier),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                            ),
                          ),
                          child: Icon(Icons.add),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 34,
                        child: Text(product.quantity.toString()),
                      ),
                      InkWell(
                        onTap: () => decreaseQty(cartNotifier),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Icon(Icons.remove),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
