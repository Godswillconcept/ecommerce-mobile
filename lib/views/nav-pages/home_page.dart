// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:ecommerce/views/components/search/search_box.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/views/utils/constant.dart';
import '../components/category/category_grid.dart';
import '../components/category/category_toggle.dart';
import '../components/deal/hot_deal_view.dart';
import '../utils/ad_card.dart';
import '../components/deal/deal_grid.dart';
import '../utils/item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TabController tabController = TabController(length: 3, vsync: this);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appBarBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * (0.12),
              decoration: BoxDecoration(
                color: appBarBg,
              ),
              child: Stack(
                children: [
                  SearchBox(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: bodyBg,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Categories',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return CategoryGrid();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                        color: Colors.blueAccent.shade200,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 20,
                                bottom: 20,
                              ),
                              child: CategoryToggle(),
                            ),
                          ],
                        ),
                      ),
                      //
                      AdCard(),
                      //
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'New Arrivals',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent.shade200,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return HotDealView();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                        color: Colors.blueAccent.shade200,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              endIndent: 20,
                              indent: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 20,
                                bottom: 10,
                                // top: 10,
                              ),
                              child: ItemCard(),
                            ),
                          ],
                        ),
                      ),
                      //
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Hot deals',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent.shade200,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return HotDealView();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                        color: Colors.blueAccent.shade200,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              endIndent: 20,
                              indent: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10,
                                // top: 10,
                              ),
                              child: DealGrid(),
                            ),
                          ],
                        ),
                      ),
                      //

                      //
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
