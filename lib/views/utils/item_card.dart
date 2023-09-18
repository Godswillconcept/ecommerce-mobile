// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:ecommerce/controllers/product_notifier.dart';
import 'package:ecommerce/views/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/request.dart';

class ItemCard extends StatelessWidget {
  ItemCard({
    Key? key,
  }) : super(key: key);

  List images = [
    'images/clothes/19.jpg',
    'images/clothes/17.jpg',
    'images/clothes/15.jpg',
    'images/clothes/13.jpg',
    'images/clothes/11.jpg',
    'images/clothes/09.jpg',
    'images/clothes/07.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Consumer<ProductNotifier>(
          builder: (context, productNotifier, child) {
            final productList = productNotifier.productList;
            return Row(
              children: List.generate(
                5,
                (i) {
                  final product = productList[i];
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 10,
                      top: 10,
                      right: 10,
                    ),
                    width: 120,
                    height: 100,
                    decoration: BoxDecoration(
                      color: bodyBg,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(baseUrl + product.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ));
  }
}
