// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, library_private_types_in_public_api, unused_local_variable

import 'package:ecommerce/views/components/order/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/views/utils/constant.dart';
import '../../controllers/order_notifier.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String _activeButton = "all_orders";

  // List<Order> myOrders = orderList;
  // List<Order> pendingOrders =
  //     orderList.where((order) => order.status == 'pending').toList();
  // List<Order> processingOrders =
  //     orderList.where((order) => order.status == 'processing').toList();
  // List<Order> deliveredOrders =
  //     orderList.where((order) => order.status == 'delivered').toList();

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderNotifier>(context, listen: false).orderList;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(color: appBarBg),
              alignment: Alignment.center,
              child: Text(
                "Orders",
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
                  height: 50,
                  color: appBarBg,
                ),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: bodyBg,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Consumer<OrderNotifier>(
                      builder: (context, orderNotifier, child) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            _buildButton(
                                                "all_orders", "All Orders"),
                                            _buildButton("pending", "Pending"),
                                            _buildButton(
                                                "processing", "Processing"),
                                            _buildButton(
                                                "delivered", "Delivered"),
                                          ],
                                        ),
                                        _buildOrderContainer(),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildButton(String buttonName, String buttonText) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeButton = buttonName;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _activeButton == buttonName ? appBarBg : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color:
                _activeButton == buttonName ? Colors.transparent : Colors.grey,
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          buttonText,
          style: TextStyle(
              color: _activeButton == buttonName ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOrderContainer() {
    final orderList =
        Provider.of<OrderNotifier>(context, listen: false).orderList;
    final pendingOrders =
        orderList.where((x) => x.status == "Pending").toList();

    final processingOrders =
        orderList.where((x) => x.status == "Processing").toList();

    final deliveredOrders =
        orderList.where((x) => x.status == "Delivered").toList();

    switch (_activeButton) {
      case "all_orders":
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: ListView.separated(
            itemCount: orderList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final order = orderList[i];
              List<Widget> orderItems = [];

              for (final detail in order.detail) {
                final productImage = detail.product.image;
                orderItems.add(
                  OrderItem(
                    details: order.detail,
                    image: productImage!, // Fixed variable name
                    product: detail.product.name, // Fixed variable name
                    total: order.total, // Fixed variable name
                    status: order.status!, // Fixed variable name
                    orderDate: order.orderDate!, // Fixed variable name
                  ),
                );
              }

              return Column(
                children: orderItems,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(thickness: 2, );
            },
          ),
        );

      case "pending":
        return Container(
          margin: EdgeInsets.only(top: 10),
          child: ListView.separated(
            itemCount: pendingOrders.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final order = pendingOrders[i];
              List<Widget> pendingItems = [];

              for (final detail in order.detail) {
                final productImage = detail.product.image;
                pendingItems.add(
                  OrderItem(
                    details: order.detail,
                    image: productImage!, // Fixed variable name
                    product: detail.product.name, // Fixed variable name
                    total: order.total, // Fixed variable name
                    status: order.status!, // Fixed variable name
                    orderDate: order.orderDate!, // Fixed variable name
                  ),
                );
              }

              return Column(
                children: pendingItems,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(thickness: 3, );
            },
          ),
        );
      case "processing":
        return Container(
          margin: EdgeInsets.only(top: 10),
        child:  ListView.separated(
            itemCount: processingOrders.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final order = processingOrders[i];
              List<Widget> processingItems = [];

              for (final detail in order.detail) {
                final productImage = detail.product.image;
                processingItems.add(
                  OrderItem(
                    details: order.detail,
                    image: productImage!, // Fixed variable name
                    product: detail.product.name, // Fixed variable name
                    total: order.total, // Fixed variable name
                    status: order.status!, // Fixed variable name
                    orderDate: order.orderDate!, // Fixed variable name
                  ),
                );
              }

              return Column(
                children: processingItems,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(thickness: 3, );
            },
          ),
        
        
        );
      case "delivered":
        return Container(
          margin: EdgeInsets.only(top: 10),
        child:   ListView.separated(
            itemCount: deliveredOrders.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              final order = deliveredOrders[i];
              List<Widget> deliveredItems = [];

              for (final detail in order.detail) {
                final productImage = detail.product.image;
                deliveredItems.add(
                  OrderItem(
                    details: order.detail,
                    image: productImage!, // Fixed variable name
                    product: detail.product.name, // Fixed variable name
                    total: order.total, // Fixed variable name
                    status: order.status!, // Fixed variable name
                    orderDate: order.orderDate!, // Fixed variable name
                  ),
                );
              }

              return Column(
                children: deliveredItems,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(thickness: 3, );
            },
          ),
        
        
        );
      default:
        return Container();
    }
  }
}
