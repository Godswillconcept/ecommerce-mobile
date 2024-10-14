// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:ecommerce/controllers/order_notifier.dart';
import 'package:ecommerce/services/request.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../controllers/cart_notifier.dart';
import '../../../models/cart.dart';
import '../../../models/user.dart';
import '../../utils/constant.dart';

class UserScreen extends StatefulWidget {
  UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final userInfo = Hive.box<User>("userBox");
  final cartInfo = Hive.box<Cart>("cartBox");

  bool status = false;
  @override
  Widget build(BuildContext context) {
    final user = userInfo.values.elementAt(0);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarBg,
      ),
      body: ListView(
        children: [
          Container(
            width: double.maxFinite,
            height: 290,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff0b63f6),
                  Color(0xff003cc5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //first child
                Container(
                  width: double.maxFinite,
                  height: 230,
                  decoration: BoxDecoration(
                    color: appBarBg,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(baseUrl + user.image!),
                              ),
                            ),
                            Positioned(
                              bottom: -5,
                              right: -15,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xffeff1fe),
                                      Color(0xfffcf1f0),
                                      Color(0xfffafcf4),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: Color(0xff003cc5),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      FontAwesomeIcons.camera,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 10),
                            child: AppLargeText(
                              text: user.name,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                text: 'Rank:',
                                color: Colors.white70,
                                size: 14.0,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              AppLargeText(
                                text: 'Regular',
                                color: Colors.white,
                                size: 16.0,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Check out for the lastest products and collections from Marazzo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: appBarBg,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff0b63f6),
                          Color(0xff003cc5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(Icons.scale_sharp, color: Colors.white),
                  ),
                ),
                AppLargeText(
                  text: 'My Overview',
                  color: Colors.white,
                  size: 16.0,
                )
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: Color(0xff0b63f6),
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff0b63f6),
                            Color(0xff003cc5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email Address",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          user.email,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff0b63f6),
                            Color(0xff003cc5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Home Address",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          user.address,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff0b63f6),
                            Color(0xff003cc5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date of birth",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat.yMMMMd().format(user.dob),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff0b63f6),
                            Color(0xff003cc5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          user.phone,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff0b63f6),
                            Color(0xff003cc5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Order",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Spacer(),
                    Consumer<OrderNotifier>(
                      builder: (context, orderNotifier, child) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "${orderNotifier.orderList.length}",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff0b63f6),
                            Color(0xff003cc5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Cart",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Spacer(),
                    Consumer<CartNotifier>(
                      builder: (context, cartNotifier, child) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "${cartNotifier.cartProducts.length}",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      },
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Logout of Marazzo?"),
                        content: Text(
                            "You can log back into your account at any time"),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder()),
                            onPressed: () {
                              _logoutUser();
                              Navigator.of(context)
                                  .pushReplacementNamed("/login");
                            },
                            child: Text('Logout'),
                          ),
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: StadiumBorder(),
                              side: BorderSide(
                                width: 2,
                                color: Colors.blue,
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff0b63f6),
                              Color(0xff003cc5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logoutUser() {
    userInfo.clear();
    context.read<OrderNotifier>().clearOrder();
  }
}
