// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api

import 'package:ecommerce/controllers/cart_notifier.dart';
import 'package:ecommerce/controllers/order_notifier.dart';
import 'package:ecommerce/services/request.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../controllers/product_notifier.dart';
import '../models/user.dart';
import 'utils/constant.dart';
import 'nav-pages/cart_page.dart';
import 'nav-pages/home_page.dart';
import 'nav-pages/product_page.dart';
import 'nav-pages/order_page.dart';
import 'nav-pages/offer_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _currentIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ProductPage(),
    OrderPage(),
    CartPage(),
    OfferPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: appBarBg,
        items: [
          Icon(
            Icons.apps_outlined,
            color: Colors.white,
          ),
          Consumer<ProductNotifier>(
            builder: (context, productNotifier, child) {
              final productList = productNotifier.productList;
              return Badge(
                label: Text((productList.length).toString()),
                child: Icon(
                  Icons.clean_hands,
                  color: Colors.white,
                ),
              );
            },
          ),
          Consumer<OrderNotifier>(
            builder: (context, orderNotifier, child) {
              final orderList = orderNotifier.orderList;
              return Badge(
                label: Text((orderList.length).toString()),
                child: Icon(
                  Icons.local_convenience_store_rounded,
                  color: Colors.white,
                ),
              );
            },
          ),
          Consumer<CartNotifier>(
            builder: (context, cartNotifier, child) {
              final productList = cartNotifier.cartProducts;
              return Badge(
                label: Text((productList.length).toString()),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
              );
            },
          ),
          Icon(
            Icons.business_center_outlined,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

AppBar buildAppbar(BuildContext context) {
  final userInfo = Hive.box<User>("userBox");
  final userDetail = userInfo.values.elementAt(0);
  return AppBar(
    elevation: 0,
    backgroundColor: appBarBg,
    leading: Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/profile'),
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(baseUrl + userDetail.image!),
        ),
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey ${userDetail.name}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Let\'s search your shopping needs.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/notifications');
        },
        icon: Icon(Icons.notifications_active_sharp),
      )
    ],
  );
}
