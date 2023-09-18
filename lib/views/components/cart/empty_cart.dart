// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('images/empty-cart.png'),
        Text(
          "Oops! Your cart is empty.",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Start adding products to your cart to continue shopping!",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
