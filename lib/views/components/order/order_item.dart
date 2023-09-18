// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ecommerce/services/request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/order.dart';

class OrderItem extends StatelessWidget {
  final List<Detail> details;
  final String image;
  final String product;
  final String total;
  final String status;
  final DateTime orderDate;
  const OrderItem({
    Key? key,
    required this.details,
    required this.image,
    required this.product,
    required this.total,
    required this.status,
    required this.orderDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = details.map((detail) => detail.product.name).toList();
    final formattedOrderDate = DateFormat.yMMMMd()
        .add_jm()
        .format(orderDate); // Format the orderDate with date and time

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Badge(
          label: Text("${products.length}"),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(baseUrl + image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: SizedBox(
          width: 200,
          child: Text(
            products.join(", "),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                "\$$total",
                style: TextStyle(
                  color: Colors.blue.shade500,
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  formattedOrderDate,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
